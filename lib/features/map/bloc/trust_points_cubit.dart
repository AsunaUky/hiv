import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/trust_point_repository.dart';
import 'trust_points_state.dart';

class TrustPointsCubit extends Cubit<TrustPointsState> {
  TrustPointsCubit(this._repository) : super(TrustPointsInitial());

  final TrustPointRepository _repository;

  /// Первичная загрузка (или смена языка без повторного сетевого запроса —
  /// кэш живёт в [TrustPointRepositoryImpl]).
  Future<void> load(String locale) async {
  emit(TrustPointsLoading());
  try {
    final points = await _repository.getPoints(locale);
    // Фильтруем точки с невалидными координатами ещё до UI
    final valid = points.where((p) =>
      p.location.latitude.isFinite &&
      p.location.longitude.isFinite
    ).toList();
    emit(TrustPointsLoaded(valid, locale));
  } catch (e) {
    emit(TrustPointsError(e.toString()));
  }
}

  /// Вызывается при смене языка из [LocaleCubit].
  ///
  /// Не показывает лоадер — данные уже в кэше репозитория,
  /// перемаппинг происходит мгновенно.
  Future<void> changeLocale(String locale) async {
    final current = state;
    if (current is TrustPointsLoaded && current.locale == locale) return;
    try {
      final points = await _repository.getPoints(locale);
      emit(TrustPointsLoaded(points, locale));
    } catch (e) {
      emit(TrustPointsError(e.toString()));
    }
  }
}