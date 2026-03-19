import 'package:flutter/material.dart';

// TODO: реализовать результат теста
class TestResultScreen extends StatelessWidget {
  const TestResultScreen({
    super.key,
    required this.score,
    required this.total,
    this.riskLevel,
    this.recommendations = const [],
  });

  final int score;
  final int total;
  final dynamic riskLevel;
  final List<String> recommendations;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Результат теста'));
  }
}