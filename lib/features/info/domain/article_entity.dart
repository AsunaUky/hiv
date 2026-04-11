/// Блок внутри статьи — необязательный заголовок раздела + абзацы + пункты.
class ArticleBlock {
  const ArticleBlock({
    this.heading,
    this.paragraphs = const [],
    this.bullets = const [],
  });

  /// Заголовок раздела (null — блок без заголовка).
  final String? heading;

  /// Обычные абзацы.
  final List<String> paragraphs;

  /// Маркированные пункты.
  final List<String> bullets;
}

/// Статья информационного раздела.
///
/// Намеренно не содержит импортов Flutter или Firebase —
/// domain-слой должен оставаться чистым Dart.
class ArticleEntity {
  const ArticleEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconCode,
    required this.blocks,
  });

  final String id;

  /// Заголовок карточки и AppBar.
  final String title;

  /// Краткое описание для карточки (1–2 предложения).
  final String subtitle;

  /// Код иконки Material (IconData.codePoint) — int, чтобы domain
  /// не импортировал Flutter.
  final int iconCode;

  /// Структурированное содержимое.
  final List<ArticleBlock> blocks;
}