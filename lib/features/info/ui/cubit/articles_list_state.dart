part of 'articles_list_cubit.dart';

abstract class ArticlesListState extends Equatable {
  @override List<Object?> get props => [];
}
class ArticlesListInitial extends ArticlesListState {}
class ArticlesListLoading extends ArticlesListState {}
class ArticlesListLoaded extends ArticlesListState {
  final List<ArticleEntity> articles;
  ArticlesListLoaded(this.articles);
  @override List<Object?> get props => [articles];
}
class ArticlesListError extends ArticlesListState {
  final String message;
  ArticlesListError(this.message);
  @override List<Object?> get props => [message];
}