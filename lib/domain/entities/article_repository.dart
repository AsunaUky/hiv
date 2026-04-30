import 'package:hiv/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  Future<List<ArticleEntity>> getAll(String locale);
  Future<ArticleEntity> getArticleById(String id, String locale);
}