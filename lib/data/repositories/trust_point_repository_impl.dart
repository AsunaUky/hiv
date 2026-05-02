import 'package:hiv/domain/entities/trust_points_entity.dart';

import '../../domain/repositories/trust_point_repository.dart';
import '../datasources/trust_points_datasource.dart';
import '../models/trust_point_model.dart';

class TrustPointRepositoryImpl implements TrustPointRepository {
  TrustPointRepositoryImpl(this._dataSource);

  final TrustPointsDataSource _dataSource;

  /// Кэш сырых моделей: при смене языка не делаем повторный сетевой запрос,
  /// а просто перемапливаем уже загруженные данные.
  List<TrustPointModel>? _cache;

  @override
  Future<List<TrustPointEntity>> getPoints(String locale) async {
    _cache ??= await _dataSource.fetchAll();
    return _cache!.map((m) => m.toEntity(locale)).toList();
  }
}