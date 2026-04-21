import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hiv/features/info/domain/article_entity.dart';

/// Блок статьи — data-слой (с сериализацией).
class ArticleBlockModel extends Equatable {
  const ArticleBlockModel({
    this.heading,
    this.paragraphs = const [],
    this.bullets = const [],
  });

  final String? heading;
  final List<String> paragraphs;
  final List<String> bullets;

  // ── JSON ────────────────────────────────────────────────────

  factory ArticleBlockModel.fromJson(Map<String, dynamic> json) {
    return ArticleBlockModel(
      heading: json['heading'] as String?,
      paragraphs:
          (json['paragraphs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bullets:
          (json['bullets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (heading != null) 'heading': heading,
      'paragraphs': paragraphs,
      'bullets': bullets,
    };
  }

  @override
  List<Object?> get props => [heading, paragraphs, bullets];
}

/// Модель статьи информационного раздела.
///
/// Расширяет [Equatable] для корректного сравнения в BLoC.
/// Содержит фабрики для JSON (Firestore) и маппинг в/из [ArticleEntity].
class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconCode,
    required this.blocks,
  });

  /// Уникальный идентификатор статьи.
  final String id;

  /// Заголовок карточки и AppBar.
  final String title;

  /// Краткое описание для карточки (1–2 предложения).
  final String subtitle;

  /// Код иконки Material (IconData.codePoint).
  final int iconCode;

  /// Структурированное содержимое статьи.
  final List<ArticleBlockModel> blocks;

  // ── JSON ────────────────────────────────────────────────────

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      iconCode: json['iconCode'] as int? ?? 0,
      blocks:
          (json['blocks'] as List<dynamic>?)
              ?.map(
                (e) => ArticleBlockModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      iconCode: data['iconCode'] as int? ?? 0,
      blocks:
          (data['blocks'] as List<dynamic>?)
              ?.map(
                (e) => ArticleBlockModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
  ArticleEntity toEntity() => ArticleEntity(
    id: id,
    title: title,
    subtitle: subtitle,
    iconCode: iconCode,
    blocks: blocks
        .map(
          (b) => ArticleBlock(
            heading: b.heading,
            paragraphs: b.paragraphs,
            bullets: b.bullets,
          ),
        )
        .toList(),
  );
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'iconCode': iconCode,
      'blocks': blocks.map((b) => b.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, title, subtitle, iconCode, blocks];
}
