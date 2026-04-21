part of 'article_cubit.dart';

abstract class ArticleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArticleInitial extends ArticleState {}
class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final ArticleEntity article;
  ArticleLoaded(this.article);
  @override
  List<Object?> get props => [article];
}

class ArticleError extends ArticleState {
  final String message;
  ArticleError(this.message);
  @override
  List<Object?> get props => [message];
}