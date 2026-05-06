import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/locale/locale_ext.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/features/test/bloc/test_cubit.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key, required this.completed});

  final TestCompleted completed;

  @override
  Widget build(BuildContext context) {
    final color = switch (completed.riskLevel) {
      'high' => Colors.red,
      'moderate' => Colors.orange,
      _ => Colors.green,
    };
    final icon = switch (completed.riskLevel) {
      'high' => Icons.warning_rounded,
      'moderate' => Icons.info_rounded,
      _ => Icons.check_circle_rounded,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
          // onPressed: () => context.go(RouteNames.test),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(icon, color: color, size: 40),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  completed.result.description,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  completed.result.recommendation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .pop();
                  },
                  child: Text(context.locale.testResultRetry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
