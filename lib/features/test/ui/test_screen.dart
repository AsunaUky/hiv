import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/locale/locale_cubit.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/features/info/domain/test_entity.dart';
import 'package:hiv/features/test/data/repositories/test_repository_impl.dart';
import 'package:hiv/features/test/data/test_remote_datasource.dart';
import 'package:hiv/features/test/ui/cubit/test_cubit.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.read<LocaleCubit>().state.languageCode;
    return BlocProvider(
      create: (_) => TestCubit(
        TestRepositoryImpl(TestRemoteDataSource(FirebaseFirestore.instance)),
      )..load(locale),
      child: const _TestView(),
    );
  }
}

class _TestView extends StatelessWidget {
  const _TestView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestCubit, TestState>(
      listener: (context, state) {
        if (state is TestCompleted) {
          context.push('/test-result', extra: state);
        }
      },
      builder: (context, state) {
        if (state is TestLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is TestError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is TestReady) {
          return _TestIntroPage(
            onStart: () => context.read<TestCubit>().startTest(),
          );
        }
        if (state is TestInProgress) {
          return _TestQuestionsPage(state: state);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// ─── Вводный экран ───────────────────────────────────────────────

class _TestIntroPage extends StatelessWidget {
  const _TestIntroPage({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.health_and_safety_outlined,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Тест оценки риска',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Ответьте на 10 вопросов о вашем поведении — система оценит уровень риска и даст персональную рекомендацию.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Все ответы анонимны и конфиденциальны. Данные не сохраняются.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStart,
                  child: const Text('Пройти тест'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Экран с вопросами ───────────────────────────────────────────

class _TestQuestionsPage extends StatelessWidget {
  const _TestQuestionsPage({required this.state});
  final TestInProgress state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${state.answeredCount} / ${state.totalQuestions}',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Прогресс-бар
          LinearProgressIndicator(
            value: state.totalQuestions > 0
                ? state.answeredCount / state.totalQuestions
                : 0,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: state.blocks.length,
              itemBuilder: (_, i) => _BlockSection(
                block: state.blocks[i],
                selectedIndexes: state.selectedIndexes,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: ElevatedButton(
          onPressed: state.allAnswered
              ? () => context.read<TestCubit>().finish()
              : null,
          child: const Text('Завершить тест'),
        ),
      ),
    );
  }
}

class _BlockSection extends StatelessWidget {
  const _BlockSection({required this.block, required this.selectedIndexes});
  final TestBlock block;
  final Map<String, int> selectedIndexes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            block.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        ...block.questions.map(
          (q) =>
              _QuestionCard(question: q, selectedIndex: selectedIndexes[q.id]),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question, required this.selectedIndex});
  final TestQuestion question;
  final int? selectedIndex; // ← индекс выбранной опции

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...question.options.asMap().entries.map(
            (entry) => _OptionTile(
              option: entry.value,
              isSelected: selectedIndex == entry.key, // ← по индексу
              onTap: () => context.read<TestCubit>().answer(
                question.id,
                entry.key, // ← индекс
                entry.value.risk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  final TestOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textHint,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
