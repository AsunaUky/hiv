import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiv/features/info/domain/repositories/test_repository.dart';
import 'package:hiv/features/info/domain/test_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  final TestRepository _repository;
  TestCubit(this._repository) : super(TestInitial());

  Future<void> load(String locale) async {
    emit(TestLoading());
    try {
      final blocks = await _repository.getBlocks(locale);
      final resultsLogic = await _repository.getResultsLogic(locale);
      emit(TestReady(blocks: blocks, resultsLogic: resultsLogic));
    } catch (e) {
      emit(TestError(e.toString()));
    }
  }

  void startTest() {
    final current = state;
    if (current is TestReady) {
      emit(TestInProgress(
        blocks: current.blocks,
        resultsLogic: current.resultsLogic,
        answers: {},
        selectedIndexes: {},
      ));
    }
  }

  void answer(String questionId, int optionIndex, String risk) {
  final current = state;
  if (current is! TestInProgress) return;
  final updatedAnswers = Map<String, String>.from(current.answers);
  final updatedIndexes = Map<String, int>.from(current.selectedIndexes);
  updatedAnswers[questionId] = risk;
  updatedIndexes[questionId] = optionIndex;

  final nextIndex = current.currentQuestionIndex + 1;

  emit(current.copyWith(
    answers: updatedAnswers,
    selectedIndexes: updatedIndexes,
    currentQuestionIndex: nextIndex,
  ));
}

void previousQuestion() {
  final current = state;
  if (current is! TestInProgress) return;
  if (current.currentQuestionIndex <= 0) return;
  emit(current.copyWith(
    currentQuestionIndex: current.currentQuestionIndex - 1,
  ));
}

  void finish() {
  final current = state;
  if (current is! TestInProgress) return;

  final values = current.answers.values.toList();
  final highCount = values.where((r) => r == 'high').length;
  final modCount = values.where((r) => r == 'mod').length;

  final String riskLevel;
  if (highCount >= 1) {
    riskLevel = 'high';
  } else if (modCount >= 2) {
    riskLevel = 'moderate';
  } else {
    riskLevel = 'minimal';
  }

  final result = switch (riskLevel) {
    'high' => current.resultsLogic.high,
    'moderate' => current.resultsLogic.moderate,
    _ => current.resultsLogic.minimal,
  };

  _saveToHistory(riskLevel);
  emit(TestCompleted(riskLevel: riskLevel, result: result));
}

Future<void> _saveToHistory(String riskLevel) async {
  final prefs = await SharedPreferences.getInstance();
  final history = prefs.getStringList('test_history') ?? [];
  final entry = jsonEncode({
    'date': DateTime.now().toIso8601String(),
    'riskLevel': riskLevel,
  });
  history.insert(0, entry);
  if (history.length > 10) history.removeLast();
  await prefs.setStringList('test_history', history);
}

Future<List<Map<String, dynamic>>> loadHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final history = prefs.getStringList('test_history') ?? [];
  return history
      .map((e) => jsonDecode(e) as Map<String, dynamic>)
      .toList();
}

  void restart() => emit(TestInitial());
}