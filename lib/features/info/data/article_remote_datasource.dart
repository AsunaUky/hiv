import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiv/data/models/article_model.dart';
import 'package:hiv/features/info/domain/article_entity.dart';

class ArticleRemoteDataSource {
  final FirebaseFirestore _firestore;
  ArticleRemoteDataSource(this._firestore);

  CollectionReference get _collection => _firestore
      .collection('artifacts')
      .doc('default')
      .collection('public')
      .doc('data')
      .collection('articles');

  Future<List<ArticleEntity>> getAll(String locale) async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => ArticleModel.fromFirestore(doc).toEntity(locale))
        .toList();
  }

  Future<ArticleEntity> getArticleById(String id, String locale) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) throw Exception('Article not found: $id');
    return ArticleModel.fromFirestore(doc).toEntity(locale);
  }
}