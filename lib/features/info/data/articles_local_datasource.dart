import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hiv/features/info/domain/article_entity.dart';

/// Локальный источник данных — три статьи.
///
/// Все строки берутся из JSON-переводов через [tr()].
/// Структура (блоки, заголовки, пункты) описана здесь в коде —
/// текст живёт в assets/translations/ru.json и kk.json.
class ArticlesLocalDatasource {
  const ArticlesLocalDatasource._();
  static const instance = ArticlesLocalDatasource._();

  /// Возвращать список нужно при каждом вызове (не кешировать),
  /// чтобы tr() отдал строки текущей локали.
  List<ArticleEntity> getAll() => [
        _whatIsHiv(),
        _myths(),
        _recommendations(),
      ];

  // ─── Статья 1 ────────────────────────────────────────────────────

  ArticleEntity _whatIsHiv() {
    const k = 'articles.whatIsHiv';
    return ArticleEntity(
      id: 'whatIsHiv',
      title: tr('$k.title'),
      subtitle: tr('$k.subtitle'),
      iconCode: Icons.info_outline_rounded.codePoint,
      blocks: [
        ArticleBlock(
          heading: tr('$k.b0_heading'),
          paragraphs: [tr('$k.b0_p0'), tr('$k.b0_p1')],
          bullets: [tr('$k.b0_bl0'), tr('$k.b0_bl1'), tr('$k.b0_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b1_heading'),
          paragraphs: [tr('$k.b1_p0'), tr('$k.b1_p1')],
          bullets: [
            tr('$k.b1_bl0'), tr('$k.b1_bl1'), tr('$k.b1_bl2'),
            tr('$k.b1_bl3'), tr('$k.b1_bl4'), tr('$k.b1_bl5'), tr('$k.b1_bl6'),
          ],
        ),
        ArticleBlock(
          heading: tr('$k.b2_heading'),
          paragraphs: [tr('$k.b2_p0')],
          bullets: [tr('$k.b2_bl0'), tr('$k.b2_bl1'), tr('$k.b2_bl2'), tr('$k.b2_bl3')],
        ),
        ArticleBlock(
          heading: tr('$k.b3_heading'),
          bullets: [tr('$k.b3_bl0'), tr('$k.b3_bl1')],
        ),
        ArticleBlock(
          heading: tr('$k.b4_heading'),
          bullets: [tr('$k.b4_bl0'), tr('$k.b4_bl1')],
        ),
        ArticleBlock(
          heading: tr('$k.b5_heading'),
          paragraphs: [tr('$k.b5_p0')],
        ),
      ],
    );
  }

  // ─── Статья 2 ────────────────────────────────────────────────────

  ArticleEntity _myths() {
    const k = 'articles.myths';
    return ArticleEntity(
      id: 'myths',
      title: tr('$k.title'),
      subtitle: tr('$k.subtitle'),
      iconCode: Icons.shield_outlined.codePoint,
      blocks: [
        ArticleBlock(
          heading: tr('$k.b0_heading'),
          bullets: [tr('$k.b0_bl0'), tr('$k.b0_bl1'), tr('$k.b0_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b1_heading'),
          bullets: [tr('$k.b1_bl0'), tr('$k.b1_bl1'), tr('$k.b1_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b2_heading'),
          bullets: [tr('$k.b2_bl0'), tr('$k.b2_bl1')],
        ),
        ArticleBlock(
          heading: tr('$k.b3_heading'),
          bullets: [tr('$k.b3_bl0'), tr('$k.b3_bl1')],
        ),
        ArticleBlock(
          heading: tr('$k.b4_heading'),
          paragraphs: [tr('$k.b4_p0')],
          bullets: [tr('$k.b4_bl0'), tr('$k.b4_bl1'), tr('$k.b4_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b5_heading'),
          bullets: [tr('$k.b5_bl0'), tr('$k.b5_bl1'), tr('$k.b5_bl2')],
        ),
      ],
    );
  }

  // ─── Статья 3 ────────────────────────────────────────────────────

  ArticleEntity _recommendations() {
    const k = 'articles.recommendations';
    return ArticleEntity(
      id: 'recommendations',
      title: tr('$k.title'),
      subtitle: tr('$k.subtitle'),
      iconCode: Icons.favorite_outline_rounded.codePoint,
      blocks: [
        ArticleBlock(
          heading: tr('$k.b0_heading'),
          bullets: [tr('$k.b0_bl0'), tr('$k.b0_bl1'), tr('$k.b0_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b1_heading'),
          paragraphs: [tr('$k.b1_p0')],
          bullets: [tr('$k.b1_bl0'), tr('$k.b1_bl1'), tr('$k.b1_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b2_heading'),
          paragraphs: [tr('$k.b2_p0')],
        ),
        ArticleBlock(
          heading: tr('$k.b3_heading'),
          paragraphs: [tr('$k.b3_p0')],
          bullets: [tr('$k.b3_bl0'), tr('$k.b3_bl1'), tr('$k.b3_bl2'), tr('$k.b3_bl3')],
        ),
        ArticleBlock(
          heading: tr('$k.b4_heading'),
          bullets: [tr('$k.b4_bl0'), tr('$k.b4_bl1'), tr('$k.b4_bl2')],
        ),
        ArticleBlock(
          heading: tr('$k.b5_heading'),
          bullets: [tr('$k.b5_bl0'), tr('$k.b5_bl1'), tr('$k.b5_bl2')],
        ),
      ],
    );
  }
}