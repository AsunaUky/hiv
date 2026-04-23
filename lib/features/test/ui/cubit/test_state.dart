part of 'test_cubit.dart';

abstract class TestState {}

class TestInitial extends TestState {}
class TestLoading extends TestState {}

class TestReady extends TestState {
  final List<TestBlock> blocks;
  final TestResultsLogic resultsLogic;
  TestReady({required this.blocks, required this.resultsLogic});
}

class TestInProgress extends TestState {
  final List<TestBlock> blocks;
  final TestResultsLogic resultsLogic;
  final Map<String, String> answers;
  final Map<String, int> selectedIndexes;

  TestInProgress({
    required this.blocks,
    required this.resultsLogic,
    required this.answers,
    required this.selectedIndexes,
  });

  TestInProgress copyWith({
    Map<String, String>? answers,
    Map<String, int>? selectedIndexes,
  }) =>
      TestInProgress(
        blocks: blocks,
        resultsLogic: resultsLogic,
        answers: answers ?? this.answers,
        selectedIndexes: selectedIndexes ?? this.selectedIndexes,
      );

  int get totalQuestions => blocks.fold(0, (sum, b) => sum + b.questions.length);
  int get answeredCount => answers.length;
  bool get allAnswered => answeredCount == totalQuestions;
}

class TestCompleted extends TestState {
  final String riskLevel;
  final TestResultCategory result;
  TestCompleted({required this.riskLevel, required this.result});
}

class TestError extends TestState {
  final String message;
  TestError(this.message);
}