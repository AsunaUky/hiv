import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trust_point_model.dart';

/// Источник данных «Пунктов доверия» из Firestore.
///
/// Использует [Future.wait] — все документы запрашиваются параллельно,
/// а не последовательно (аналогично оптимизации в getBlocks для теста).
abstract class TrustPointsDataSource {
  Future<List<TrustPointModel>> fetchAll();
}

class TrustPointsRemoteDataSource implements TrustPointsDataSource {
  TrustPointsRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('trust_points');

  /// Идентификаторы всех документов коллекции /trust_points/.
  ///
  /// Список фиксирован и соответствует засеянным документам.
  /// Если добавятся новые точки — добавьте id сюда.
  static const _docIds = [
    'gp2',
    'gp4',
    'gp5',
    'gp7',
    'gp8',
    'gp9_trust',
    'gp9_spec',
    'gp10',
    'gp11',
    'gp23',
    'gp36',
    'gkv d',
    'almaty_aids_center',
  ];

  @override
  Future<List<TrustPointModel>> fetchAll() async {
    // Параллельный fetch — аналог оптимизации Future.wait в тесте.
    final docs = await Future.wait(
      _docIds.map((id) => _collection.doc(id).get()),
    );

    return docs
        .where((doc) => doc.exists)
        .map((doc) => TrustPointModel.fromFirestore(doc))
        .toList();
  }
}