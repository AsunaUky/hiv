// Чистый Dart — ноль импортов Flutter / Firebase.

import 'package:latlong2/latlong.dart';

/// Категория пункта доверия — определяет иконку и цвет маркера.
enum TrustPointCategory {
  polyclinic,
  dermatoVenerologic,
  aidsCenter,
}

/// Локализованная сущность одного «Пункта доверия».
///
/// Все текстовые поля уже переведены на нужный язык —
/// локализация происходит при маппинге модели → entity
/// (см. TrustPointModel.toEntity).
class TrustPointEntity {
  final String id;
  final String title;
  final String address;
  final String hours;
  final List<String> services;
  final TrustPointCategory category;
  final LatLng location;

  const TrustPointEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.hours,
    required this.services,
    required this.category,
    required this.location,
  });
}