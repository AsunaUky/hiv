import 'package:hiv/features/info/domain/article_entity.dart';

abstract class ArticleRepository {
  Future<ArticleEntity> getArticleById(String id);
  Future<List<ArticleEntity>> getAll();
}