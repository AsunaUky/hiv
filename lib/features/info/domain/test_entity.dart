class TestOption {
  final String text;
  final String risk; // "min" | "mod" | "high"
  final String? comment;
  const TestOption({required this.text, required this.risk, this.comment});
}

class TestQuestion {
  final String id;
  final String text;
  final List<TestOption> options;
  const TestQuestion({required this.id, required this.text, required this.options});
}

class TestBlock {
  final String id;
  final String title;
  final List<TestQuestion> questions;
  const TestBlock({required this.id, required this.title, required this.questions});
}

class TestResultCategory {
  final String description;
  final String recommendation;
  const TestResultCategory({required this.description, required this.recommendation});
}

class TestResultsLogic {
  final TestResultCategory minimal;
  final TestResultCategory moderate;
  final TestResultCategory high;
  const TestResultsLogic({required this.minimal, required this.moderate, required this.high});
}