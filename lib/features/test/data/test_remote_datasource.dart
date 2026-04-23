import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiv/data/models/test_model.dart';
import 'package:hiv/features/info/domain/test_entity.dart';

class TestRemoteDataSource {
  final FirebaseFirestore _firestore;
  TestRemoteDataSource(this._firestore);

  // Путь: /test_metadata_multilingual/
  CollectionReference get _collection =>
      _firestore.collection('test_metadata_multilingual');

  Future<List<TestBlock>> getBlocks(String locale) async {
    final blockIds = ['block_0', 'block_1', 'block_2', 'block_3'];
    final blocks = <TestBlock>[];
    for (final id in blockIds) {
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        blocks.add(TestBlockModel.fromFirestore(doc).toEntity(locale));
      }
    }
    return blocks;
  }

  Future<TestResultsLogic> getResultsLogic(String locale) async {
    final doc = await _collection.doc('results_logic').get();
    return TestResultsLogicModel.fromFirestore(doc).toEntity(locale);
  }
}