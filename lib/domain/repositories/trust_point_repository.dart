import 'package:hiv/domain/entities/trust_points_entity.dart';

abstract class TrustPointRepository {
  /// Возвращает список точек, уже переведённых на [locale] ('ru' или 'kk').
  Future<List<TrustPointEntity>> getPoints(String locale);
}