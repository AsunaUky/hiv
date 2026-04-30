import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiv/domain/repositories/test_repository.dart';
import 'package:hiv/domain/entities/test_entity.dart';

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
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('test_history')
      .add({
    'riskLevel': riskLevel,
    'date': FieldValue.serverTimestamp(),
  });
}

Future<List<Map<String, dynamic>>> loadHistory() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('test_history')
      .orderBy('date', descending: true)
      .limit(10)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    final timestamp = data['date'] as Timestamp?;
    return {
      'riskLevel': data['riskLevel'] as String,
      'date': timestamp?.toDate().toIso8601String() ??
          DateTime.now().toIso8601String(),
    };
  }).toList();
}

  void restart() => emit(TestInitial());
}