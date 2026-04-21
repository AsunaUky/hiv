import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiv/features/info/domain/article_entity.dart';
import 'package:hiv/features/info/domain/repositories/article_repository.dart';

part 'articles_list_state.dart';

class ArticlesListCubit extends Cubit<ArticlesListState> {
  final ArticleRepository _repository;
  ArticlesListCubit(this._repository) : super(ArticlesListInitial());

  Future<void> loadAll() async {
    emit(ArticlesListLoading());
    try {
      final articles = await _repository.getAll();
      emit(ArticlesListLoaded(articles));
    } catch (e) {
      emit(ArticlesListError(e.toString()));
    }
  }
}