import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/locale/locale_cubit.dart';
import 'package:hiv/core/locale/locale_ext.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/domain/entities/test_entity.dart';
import 'package:hiv/features/test/bloc/test_cubit.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TestCubit>();
    if (cubit.state is TestInitial) {
      final locale = context.read<LocaleCubit>().state.languageCode;
      cubit.load(locale);
    }
  }

  @override
  Widget build(BuildContext context) => const _TestView();
}

class _TestView extends StatelessWidget {
  const _TestView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestCubit, TestState>(
      listener: (context, state) async {
        if (state is TestCompleted) {
          await context.push(RouteNames.testResult, extra: state);
          if (context.mounted) {
            context.read<TestCubit>().restart();
          }
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
  List<Map<String, dynamic>>? _history; // null = ещё грузится
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
              Text(
                l.testTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l.testDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l.testPrivacyNote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (_history == null || _history!.isEmpty)
                const SizedBox(height: 48)
              else if (_history!.isNotEmpty) ...[
                GestureDetector(
                  onTap: () =>
                      setState(() => _historyExpanded = !_historyExpanded),
                  child: Row(
                    children: [
                      Text(
                        l.testHistoryTitle(_history!.length),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _historyExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ),
                if (_historyExpanded) ...[
                  const SizedBox(height: 8),
                  ..._history!.map((entry) {
                    final risk = entry['riskLevel'] as String;
                    final dateStr = entry['date'] as String;
                    final date = DateTime.tryParse(dateStr);
                    final color = switch (risk) {
                      'high' => Colors.red,
                      'moderate' => Colors.orange,
                      _ => Colors.green,
                    };
                    final label = switch (risk) {
                      'high' => l.testRiskHigh,
                      'moderate' => l.testRiskModerate,
                      _ => l.testRiskMinimal,
                    };
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(label,
                              style: TextStyle(color: color, fontSize: 13)),
                          const Spacer(),
                          if (date != null)
                            Text(
                              '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                              style: const TextStyle(
                                  color: AppColors.textHint, fontSize: 12),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onStart,
                  child: Text(l.testStartButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestQuestionsPage extends StatelessWidget {
  const _TestQuestionsPage({required this.state});
  final TestInProgress state;

  @override
  Widget build(BuildContext context) {
    final isLastAnswered =
        state.totalQuestions > 0 &&
        state.currentQuestionIndex >= state.totalQuestions;
    final question = isLastAnswered
        ? null
        : (state.currentQuestionIndex < state.allQuestions.length
            ? state.allQuestions[state.currentQuestionIndex]
            : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (state.currentQuestionIndex > 0) {
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
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 4,
            ),
          ),
          if (question != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.currentBlockTitle,
                  style: const TextStyle(
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
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.primary,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.locale.testAllQuestionsAnswered,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => context.read<TestCubit>().finish(),
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
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}