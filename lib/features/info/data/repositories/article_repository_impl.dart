import 'package:hiv/features/info/domain/article_entity.dart';
import 'package:hiv/features/info/domain/repositories/article_repository.dart';
import 'package:hiv/features/info/data/article_remote_datasource.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource _dataSource;
  ArticleRepositoryImpl(this._dataSource);

  @override
  Future<ArticleEntity> getArticleById(String id) =>
      _dataSource.getArticleById(id);

  @override
  Future<List<ArticleEntity>> getAll() => _dataSource.getAll();
}