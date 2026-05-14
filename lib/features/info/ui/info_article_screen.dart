import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/domain/entities/article_entity.dart';

/// Экран чтения статьи (без BottomNavigationBar).
///
/// Кнопка «назад» в AppBar всегда возвращает к [InfoListScreen]
/// через [context.go(RouteNames.info)] — не зависит от истории
/// навигации и не ломает стек при deep link.
class InfoArticleScreen extends StatelessWidget {
  const InfoArticleScreen({super.key, required this.article});

  final ArticleEntity article;

  IconData _iconData(int codePoint) {
    const map = {
      0xe5c4: Icons.arrow_back,
      0xe88a: Icons.home,
    };
    return map[codePoint] ?? Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          // Всегда возвращаемся к списку, а не просто pop()
          onPressed: () => context.go(RouteNames.info),
        ),
        title: Text(
          article.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Иконка статьи
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _iconData(article.iconCode),
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),

              // Блоки контента
              ...article.blocks.map(
                (block) => _ArticleBlockWidget(block: block),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Рендер одного блока ─────────────────────────────────────────

class _ArticleBlockWidget extends StatelessWidget {
  const _ArticleBlockWidget({required this.block});
  final ArticleBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.heading != null) ...[
            Text(
              block.heading!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
          ],
          for (final para in block.paragraphs) ...[
            Text(
              para,
              style: const TextStyle(
                fontSize: 15,
                height: 1.65,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          for (final bullet in block.bullets) ...[
            _BulletItem(text: bullet),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    // Текст может содержать \n внутри (напр. «Миф: ...\nРеальность: ...»)
    // Разбиваем на строки и делаем первую строку чуть жирнее.
    final lines = text.split('\n');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < lines.length; i++)
                Text(
                  lines[i],
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    color: AppColors.textPrimary,
                    fontWeight: i == 0 && lines.length > 1
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}