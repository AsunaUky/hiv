import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/locale/locale_cubit.dart';
import 'package:hiv/core/locale/locale_ext.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/domain/entities/test_entity.dart';
import 'package:hiv/data/repositories/test_repository_impl.dart';
import 'package:hiv/data/datasources/test_remote_datasource.dart';
import 'package:hiv/features/test/bloc/test_cubit.dart';

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

class _TestIntroPage extends StatefulWidget {
  const _TestIntroPage({required this.onStart});
  final VoidCallback onStart;

  @override
  State<_TestIntroPage> createState() => _TestIntroPageState();
}

class _TestIntroPageState extends State<_TestIntroPage> {
  List<Map<String, dynamic>> _history = [];
  bool _historyExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await context.read<TestCubit>().loadHistory();
    if (mounted) setState(() => _history = history);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.locale;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                l.testTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l.testDescription,
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
                        l.testPrivacyNote,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              if (_history.isNotEmpty) ...[
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () =>
                      setState(() => _historyExpanded = !_historyExpanded),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l.testHistoryTitle(
                              _history.length,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _historyExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _historyExpanded
                      ? Column(
                          children: _history
                              .map((e) => _HistoryItem(entry: e))
                              .toList(),
                        )
                      : const SizedBox.shrink(),
                ),
              ],

              const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onStart,
            child: Text(l.testStartButton),
          ),
        ),
        const SizedBox(height: 16),
      ],
    )
   )
    )
  );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.entry});
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(entry['date'] as String);
    final riskLevel = entry['riskLevel'] as String;

    final label = switch (riskLevel) {
      'high' => context.locale.testRiskHigh,
      'moderate' => context.locale.testRiskModerate,
      _ => context.locale.testRiskMinimal,
    };

    final color = switch (riskLevel) {
      'high' => Colors.red,
      'moderate' => Colors.orange,
      _ => Colors.green,
    };
    final icon = switch (riskLevel) {
      'high' => Icons.warning_rounded,
      'moderate' => Icons.info_rounded,
      _ => Icons.check_circle_rounded,
    };

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestQuestionsPage extends StatelessWidget {
  const _TestQuestionsPage({required this.state});
  final TestInProgress state;

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;
    final isLastAnswered = state.allAnswered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (state.currentQuestionIndex > 0) {
              // Шаг назад
              context.read<TestCubit>().previousQuestion();
            } else {
              context.read<TestCubit>().restart();
            }
          },
        ),
        title: Text(
          '${state.answeredCount} / ${state.totalQuestions}',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ─── Анимированный прогресс-бар ───
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: state.totalQuestions > 0
                  ? state.answeredCount / state.totalQuestions
                  : 0,
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 4,
            ),
          ),

          // ─── Заголовок блока ───
          if (question != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.currentBlockTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

          Expanded(
            child: isLastAnswered
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.primary,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Все вопросы пройдены!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.read<TestCubit>().finish(),
                              child: Text(context.locale.testFinishButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : question != null
                ? _SingleQuestionView(
                    question: question,
                    selectedIndex: state.selectedIndexes[question.id],
                    questionNumber: state.currentQuestionIndex + 1,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

// ─── Один вопрос ─────────────────────────────────────────────────

class _SingleQuestionView extends StatelessWidget {
  const _SingleQuestionView({
    required this.question,
    required this.questionNumber,
    this.selectedIndex,
  });
  final TestQuestion question;
  final int? selectedIndex;
  final int questionNumber;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.15, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: KeyedSubtree(
        key: ValueKey(question.id),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                question.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ...question.options.asMap().entries.map(
                (entry) => _OptionTile(
                  option: entry.value,
                  isSelected: selectedIndex == entry.key,
                  onTap: () => context.read<TestCubit>().answer(
                    question.id,
                    entry.key,
                    entry.value.risk,
                  ),
                ),
              ),
            ],
          ),
        ),
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
