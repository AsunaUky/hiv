import 'package:hiv/data/datasources/article_remote_datasource.dart';
import 'package:hiv/domain/entities/article_entity.dart';
import 'package:hiv/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource _dataSource;
  ArticleRepositoryImpl(this._dataSource);

  @override
  Future<List<ArticleEntity>> getAll(String locale) =>
      _dataSource.getAll(locale);

  @override
  Future<ArticleEntity> getArticleById(String id, String locale) =>
      _dataSource.getArticleById(id, locale);
}