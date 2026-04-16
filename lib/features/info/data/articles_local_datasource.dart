import 'package:flutter/material.dart';
import 'package:hiv/features/info/domain/article_entity.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

class ArticlesLocalDatasource {
  const ArticlesLocalDatasource._();
  static const instance = ArticlesLocalDatasource._();

  List<ArticleEntity> getAll(AppLocalizations l) => [
        _whatIsHiv(l),
        _myths(l),
        _recommendations(l),
      ];

  ArticleEntity _whatIsHiv(AppLocalizations l) => ArticleEntity(
        id: 'what-is-hiv',
        title: l.hivTitle,
        subtitle: l.hivSubtitle,
        iconCode: Icons.info_outline_rounded.codePoint,
        blocks: [
          ArticleBlock(
            heading: l.hivB0Heading,
            paragraphs: [l.hivB0P0, l.hivB0P1],
            bullets: [l.hivB0Bl0, l.hivB0Bl1, l.hivB0Bl2],
          ),
          ArticleBlock(
            heading: l.hivB1Heading,
            paragraphs: [l.hivB1P0, l.hivB1P1],
            bullets: [
              l.hivB1Bl0, l.hivB1Bl1, l.hivB1Bl2,
              l.hivB1Bl3, l.hivB1Bl4, l.hivB1Bl5, l.hivB1Bl6,
            ],
          ),
          ArticleBlock(
            heading: l.hivB2Heading,
            paragraphs: [l.hivB2P0],
            bullets: [l.hivB2Bl0, l.hivB2Bl1, l.hivB2Bl2, l.hivB2Bl3],
          ),
          ArticleBlock(
            heading: l.hivB3Heading,
            bullets: [l.hivB3Bl0, l.hivB3Bl1],
          ),
          ArticleBlock(
            heading: l.hivB4Heading,
            bullets: [l.hivB4Bl0, l.hivB4Bl1],
          ),
          ArticleBlock(
            heading: l.hivB5Heading,
            paragraphs: [l.hivB5P0],
          ),
        ],
      );

  ArticleEntity _myths(AppLocalizations l) => ArticleEntity(
        id: 'myths',
        title: l.mythsTitle,
        subtitle: l.mythsSubtitle,
        iconCode: Icons.shield_outlined.codePoint,
        blocks: [
          ArticleBlock(
            heading: l.mythsB0Heading,
            bullets: [l.mythsB0Bl0, l.mythsB0Bl1, l.mythsB0Bl2],
          ),
          ArticleBlock(
            heading: l.mythsB1Heading,
            bullets: [l.mythsB1Bl0, l.mythsB1Bl1, l.mythsB1Bl2],
          ),
          ArticleBlock(
            heading: l.mythsB2Heading,
            bullets: [l.mythsB2Bl0, l.mythsB2Bl1],
          ),
          ArticleBlock(
            heading: l.mythsB3Heading,
            bullets: [l.mythsB3Bl0, l.mythsB3Bl1],
          ),
          ArticleBlock(
            heading: l.mythsB4Heading,
            paragraphs: [l.mythsB4P0],
            bullets: [l.mythsB4Bl0, l.mythsB4Bl1, l.mythsB4Bl2],
          ),
          ArticleBlock(
            heading: l.mythsB5Heading,
            bullets: [l.mythsB5Bl0, l.mythsB5Bl1, l.mythsB5Bl2],
          ),
        ],
      );

  ArticleEntity _recommendations(AppLocalizations l) => ArticleEntity(
        id: 'recommendations',
        title: l.recTitle,
        subtitle: l.recSubtitle,
        iconCode: Icons.favorite_outline_rounded.codePoint,
        blocks: [
          ArticleBlock(
            heading: l.recB0Heading,
            bullets: [l.recB0Bl0, l.recB0Bl1, l.recB0Bl2],
          ),
          ArticleBlock(
            heading: l.recB1Heading,
            paragraphs: [l.recB1P0],
            bullets: [l.recB1Bl0, l.recB1Bl1, l.recB1Bl2],
          ),
          ArticleBlock(
            heading: l.recB2Heading,
            paragraphs: [l.recB2P0],
          ),
          ArticleBlock(
            heading: l.recB3Heading,
            paragraphs: [l.recB3P0],
            bullets: [l.recB3Bl0, l.recB3Bl1, l.recB3Bl2, l.recB3Bl3],
          ),
          ArticleBlock(
            heading: l.recB4Heading,
            bullets: [l.recB4Bl0, l.recB4Bl1, l.recB4Bl2],
          ),
          ArticleBlock(
            heading: l.recB5Heading,
            bullets: [l.recB5Bl0, l.recB5Bl1, l.recB5Bl2],
          ),
        ],
      );
}