import 'package:hiv/domain/repositories/test_repository.dart';
import 'package:hiv/domain/entities/test_entity.dart';
import 'package:hiv/data/datasources/test_remote_datasource.dart';


class TestRepositoryImpl implements TestRepository {
  final TestRemoteDataSource _dataSource;
  TestRepositoryImpl(this._dataSource);

  @override
  Future<List<TestBlock>> getBlocks(String locale) =>
      _dataSource.getBlocks(locale);

  @override
  Future<TestResultsLogic> getResultsLogic(String locale) =>
      _dataSource.getResultsLogic(locale);
}