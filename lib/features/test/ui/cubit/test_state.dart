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
  final int currentQuestionIndex;

  TestInProgress({
    required this.blocks,
    required this.resultsLogic,
    required this.answers,
    required this.selectedIndexes,
    this.currentQuestionIndex = 0,
  });

  TestInProgress copyWith({
    Map<String, String>? answers,
    Map<String, int>? selectedIndexes,
    int? currentQuestionIndex,
  }) =>
      TestInProgress(
        blocks: blocks,
        resultsLogic: resultsLogic,
        answers: answers ?? this.answers,
        selectedIndexes: selectedIndexes ?? this.selectedIndexes,
        currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      );

  List<TestQuestion> get allQuestions =>
      blocks.expand((b) => b.questions).toList();

  int get totalQuestions => allQuestions.length;
  int get answeredCount => answers.length;
  bool get allAnswered => answeredCount == totalQuestions;

  TestQuestion? get currentQuestion =>
      currentQuestionIndex < totalQuestions
          ? allQuestions[currentQuestionIndex]
          : null;

  String get currentBlockTitle {
    int count = 0;
    for (final block in blocks) {
      count += block.questions.length;
      if (currentQuestionIndex < count) return block.title;
    }
    return '';
  }
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