import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiv/data/models/test_model.dart';
import 'package:hiv/domain/entities/test_entity.dart';

class TestRemoteDataSource {
  final FirebaseFirestore _firestore;
  TestRemoteDataSource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection('test_metadata_multilingual');

  Future<List<TestBlock>> getBlocks(String locale) async {
    const blockIds = ['block_0', 'block_1', 'block_2', 'block_3'];

    final docs = await Future.wait(
      blockIds.map((id) => _collection.doc(id).get()),
    );

    return docs
        .where((doc) => doc.exists)
        .map((doc) => TestBlockModel.fromFirestore(doc).toEntity(locale))
        .toList();
  }

  Future<TestResultsLogic> getResultsLogic(String locale) async {
    final doc = await _collection.doc('results_logic').get();
    return TestResultsLogicModel.fromFirestore(doc).toEntity(locale);
  }
}