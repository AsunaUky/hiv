import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/features/info/data/articles_local_datasource.dart';
import 'package:hiv/features/info/domain/article_entity.dart';

/// Вкладка «Информация» — список из трёх статей.
///
/// Находится внутри ShellRoute → BottomNavigationBar виден.
class InfoListScreen extends StatelessWidget {
  const InfoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = ArticlesLocalDatasource.instance.getAll();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
              child: Text(
                tr('info.title'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                itemCount: articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) =>
                    _ArticleCard(article: articles[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Карточка статьи ─────────────────────────────────────────────

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(RouteNames.infoArticle, extra: article),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _ArticleIcon(codePoint: article.iconCode),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleIcon extends StatelessWidget {
  const _ArticleIcon({required this.codePoint});
  final int codePoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        IconData(codePoint, fontFamily: 'MaterialIcons'),
        color: AppColors.primary,
        size: 26,
      ),
    );
  }
}