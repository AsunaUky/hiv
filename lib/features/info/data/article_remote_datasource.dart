import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiv/data/models/article_model.dart';
import 'package:hiv/features/info/domain/article_entity.dart';

class ArticleRemoteDataSource {
  final FirebaseFirestore _firestore;

  ArticleRemoteDataSource(this._firestore);

  Future<ArticleEntity> getArticleById(String id) async {
    final doc = await _firestore.collection('articles').doc(id).get();

    if (!doc.exists) throw Exception('Article not found: $id');
    return ArticleModel.fromFirestore(doc).toEntity(); 
  }
  Future<List<ArticleEntity>> getAll() async {
  final snapshot = await _firestore.collection('articles').get();
  return snapshot.docs
      .map((doc) => ArticleModel.fromFirestore(doc).toEntity())
      .toList();
}
}