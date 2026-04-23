import 'package:hiv/features/info/domain/test_entity.dart';

abstract class TestRepository {
  Future<List<TestBlock>> getBlocks(String locale);
  Future<TestResultsLogic> getResultsLogic(String locale);
}