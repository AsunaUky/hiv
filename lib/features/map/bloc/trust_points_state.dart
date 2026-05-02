import 'package:hiv/domain/entities/trust_points_entity.dart';

sealed class TrustPointsState {}

class TrustPointsInitial extends TrustPointsState {}

class TrustPointsLoading extends TrustPointsState {}

class TrustPointsLoaded extends TrustPointsState {
  TrustPointsLoaded(this.points, this.locale);
  final List<TrustPointEntity> points;
  final String locale;
}

class TrustPointsError extends TrustPointsState {
  TrustPointsError(this.message);
  final String message;
}