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
        title: l.articlesWhatIsHivTitle,
        subtitle: l.articlesWhatIsHivSubtitle,
        iconCode: Icons.info_outline_rounded.codePoint,
        blocks: [
          ArticleBlock(
            heading: l.articlesWhatIsHivB0Heading,
            paragraphs: [l.articlesWhatIsHivB0P0, l.articlesWhatIsHivB0P1],
            bullets: [l.articlesWhatIsHivB0Bl0, l.articlesWhatIsHivB0Bl1, l.articlesWhatIsHivB0Bl2],
          ),
          ArticleBlock(
            heading: l.articlesWhatIsHivB1Heading,
            paragraphs: [l.articlesWhatIsHivB1P0, l.articlesWhatIsHivB1P1],
            bullets: [
              l.articlesWhatIsHivB1Bl0,
              l.articlesWhatIsHivB1Bl1,
              l.articlesWhatIsHivB1Bl2,
              l.articlesWhatIsHivB1Bl3,
              l.articlesWhatIsHivB1Bl4,
              l.articlesWhatIsHivB1Bl5,
              l.articlesWhatIsHivB1Bl6,
            ],
          ),
          ArticleBlock(
            heading: l.articlesWhatIsHivB2Heading,
            paragraphs: [l.articlesWhatIsHivB2P0],
            bullets: [
              l.articlesWhatIsHivB2Bl0,
              l.articlesWhatIsHivB2Bl1,
              l.articlesWhatIsHivB2Bl2,
              l.articlesWhatIsHivB2Bl3,
            ],
          ),
          ArticleBlock(
            heading: l.articlesWhatIsHivB3Heading,
            bullets: [l.articlesWhatIsHivB3Bl0, l.articlesWhatIsHivB3Bl1],
          ),
          ArticleBlock(
            heading: l.articlesWhatIsHivB4Heading,
            bullets: [l.articlesWhatIsHivB4Bl0, l.articlesWhatIsHivB4Bl1],
          ),
          ArticleBlock(
            heading: l.articlesWhatIsHivB5Heading,
            paragraphs: [l.articlesWhatIsHivB5P0],
          ),
        ],
      );

  ArticleEntity _myths(AppLocalizations l) => ArticleEntity(
        id: 'myths',
        title: l.articlesMythsTitle,
        subtitle: l.articlesMythsSubtitle,
        iconCode: Icons.shield_outlined.codePoint,
        blocks: [
          ArticleBlock(
            heading: l.articlesMythsB0Heading,
            bullets: [l.articlesMythsB0Bl0, l.articlesMythsB0Bl1, l.articlesMythsB0Bl2],
          ),
          ArticleBlock(
            heading: l.articlesMythsB1Heading,
            bullets: [l.articlesMythsB1Bl0, l.articlesMythsB1Bl1, l.articlesMythsB1Bl2],
          ),
          ArticleBlock(
            heading: l.articlesMythsB2Heading,
            bullets: [l.articlesMythsB2Bl0, l.articlesMythsB2Bl1],
          ),
          ArticleBlock(
            heading: l.articlesMythsB3Heading,
            bullets: [l.articlesMythsB3Bl0, l.articlesMythsB3Bl1],
          ),
          ArticleBlock(
            heading: l.articlesMythsB4Heading,
            paragraphs: [l.articlesMythsB4P0],
            bullets: [l.articlesMythsB4Bl0, l.articlesMythsB4Bl1, l.articlesMythsB4Bl2],
          ),
          ArticleBlock(
            heading: l.articlesMythsB5Heading,
            bullets: [l.articlesMythsB5Bl0, l.articlesMythsB5Bl1, l.articlesMythsB5Bl2],
          ),
        ],
      );

  ArticleEntity _recommendations(AppLocalizations l) => ArticleEntity(
        id: 'recommendations',
        title: l.articlesRecommendationsTitle,
        subtitle: l.articlesRecommendationsSubtitle,
        iconCode: Icons.favorite_outline_rounded.codePoint,
        blocks: [
          ArticleBlock(
            heading: l.articlesRecommendationsB0Heading,
            bullets: [l.articlesRecommendationsB0Bl0, l.articlesRecommendationsB0Bl1, l.articlesRecommendationsB0Bl2],
          ),
          ArticleBlock(
            heading: l.articlesRecommendationsB1Heading,
            paragraphs: [l.articlesRecommendationsB1P0],
            bullets: [l.articlesRecommendationsB1Bl0, l.articlesRecommendationsB1Bl1, l.articlesRecommendationsB1Bl2],
          ),
          ArticleBlock(
            heading: l.articlesRecommendationsB2Heading,
            paragraphs: [l.articlesRecommendationsB2P0],
          ),
          ArticleBlock(
            heading: l.articlesRecommendationsB3Heading,
            paragraphs: [l.articlesRecommendationsB3P0],
            bullets: [
              l.articlesRecommendationsB3Bl0,
              l.articlesRecommendationsB3Bl1,
              l.articlesRecommendationsB3Bl2,
              l.articlesRecommendationsB3Bl3,
            ],
          ),
          ArticleBlock(
            heading: l.articlesRecommendationsB4Heading,
            bullets: [l.articlesRecommendationsB4Bl0, l.articlesRecommendationsB4Bl1, l.articlesRecommendationsB4Bl2],
          ),
          ArticleBlock(
            heading: l.articlesRecommendationsB5Heading,
            bullets: [l.articlesRecommendationsB5Bl0, l.articlesRecommendationsB5Bl1, l.articlesRecommendationsB5Bl2],
          ),
        ],
      );
}