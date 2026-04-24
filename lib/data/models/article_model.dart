import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hiv/features/info/domain/article_entity.dart';

class ArticleBlockModel extends Equatable {
  const ArticleBlockModel({required this.type, required this.content});

  final String type;
  final Map<String, String> content;

  factory ArticleBlockModel.fromJson(Map<String, dynamic> json) {
    return ArticleBlockModel(
      type: json['type'] as String,
      content: Map<String, String>.from(json['content'] as Map),
    );
  }

  @override
  List<Object?> get props => [type, content];
}

class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconCode,
    required this.blocks,
  });

  final String id;
  final Map<String, String> title;
  final Map<String, String> subtitle;
  final String iconCode;
  final List<ArticleBlockModel> blocks;

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: Map<String, String>.from(data['title'] as Map),
      subtitle: Map<String, String>.from(data['subtitle'] as Map),
      iconCode: data['iconCode'] as String? ?? 'info',
      blocks:
          (data['blocks'] as List<dynamic>?)
              ?.map(
                (e) => ArticleBlockModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }

  ArticleEntity toEntity(String locale) {
    return ArticleEntity(
      id: id,
      title: title[locale] ?? title['ru'] ?? '',
      subtitle: subtitle[locale] ?? subtitle['ru'] ?? '',
      iconCode: _iconNameToCode(iconCode),
      blocks: _buildBlocks(locale),
    );
  }

  List<ArticleBlock> _buildBlocks(String locale) {
    final result = <ArticleBlock>[];
    String? currentHeading;
    final paragraphs = <String>[];

    for (final block in blocks) {
      final text = block.content[locale] ?? block.content['ru'] ?? '';
      if (block.type == 'heading') {
        // Сохраняем предыдущий блок если есть
        if (currentHeading != null || paragraphs.isNotEmpty) {
          result.add(
            ArticleBlock(
              heading: currentHeading,
              paragraphs: List.from(paragraphs),
            ),
          );
          paragraphs.clear();
        }
        currentHeading = text;
      } else if (block.type == 'paragraph') {
        paragraphs.add(text);
      }
    }

    // Последний блок
    if (currentHeading != null || paragraphs.isNotEmpty) {
      result.add(
        ArticleBlock(
          heading: currentHeading,
          paragraphs: List.from(paragraphs),
        ),
      );
    }

    return result;
  }

  // Строковое имя иконки → codePoint
  static int _iconNameToCode(String name) {
    const map = {
      'medication': 0xf05e0,
      'biotech': 0xea3a,
      'verified': 0xe699,
      'quiz': 0xf042f,
      'info': 0xe88e,
      'shield': 0xe9e0,
      'favorite': 0xe87d,
    };
    return map[name] ?? 0xe88e;
  }

  @override
  List<Object?> get props => [id, title, subtitle, iconCode, blocks];
}
