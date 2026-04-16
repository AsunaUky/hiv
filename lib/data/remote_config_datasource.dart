import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteConfigDatasource {
  final FirebaseFirestore _firestore;

  RemoteConfigDatasource(this._firestore);

  /// Получаем документ с локализацией по фиксированному пути
  Future<Map<String, dynamic>?> getStringConfig(String appId) async {
    final doc = await _firestore
        .collection('artifacts')
        .doc(appId)
        .collection('public')
        .doc('data')
        .collection('localization') // Создадим отдельную подколлекцию для строк
        .doc('ui_strings')
        .get();

    return doc.data();
  }
}