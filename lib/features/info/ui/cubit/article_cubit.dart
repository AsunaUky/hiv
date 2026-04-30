import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiv/domain/entities/article_entity.dart';
import 'package:hiv/domain/entities/article_repository.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final ArticleRepository _repository;
  ArticleCubit(this._repository) : super(ArticleInitial());

  Future<void> loadArticle(String id, String locale) async {
    emit(ArticleLoading());
    try {
      final article = await _repository.getArticleById(id, locale);
      emit(ArticleLoaded(article));
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }
}
