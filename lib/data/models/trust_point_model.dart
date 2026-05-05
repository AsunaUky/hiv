import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiv/domain/entities/trust_points_entity.dart';
import 'package:latlong2/latlong.dart';

/// DTO для документа коллекции /trust_points/.
///
/// Хранит оба языковых варианта каждого поля.
/// Координаты вынесены в статическую карту [_coordinates], потому что
/// в Firestore они не заведены: географические координаты не меняются
/// без переезда учреждения, поэтому хранить их в коде — оправданно.
class TrustPointModel {
  final String id;
  final String titleRu;
  final String titleKz;
  final String addressRu;
  final String addressKz;
  final String hours;
  final List<String> servicesRu;
  final List<String> servicesKz;

  const TrustPointModel({
    required this.id,
    required this.titleRu,
    required this.titleKz,
    required this.addressRu,
    required this.addressKz,
    required this.hours,
    required this.servicesRu,
    required this.servicesKz,
  });

  // ---------------------------------------------------------------------------
  // Firestore → Model
  // ---------------------------------------------------------------------------

  factory TrustPointModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return TrustPointModel(
      id: d['id'] as String? ?? doc.id,
      titleRu: d['title_ru'] as String? ?? '',
      titleKz: d['title_kz'] as String? ?? '',
      addressRu: d['address_ru'] as String? ?? '',
      addressKz: d['address_kz'] as String? ?? '',
      hours: d['hours'] as String? ?? '',
      servicesRu: List<String>.from(d['services_ru'] as List? ?? []),
      servicesKz: List<String>.from(d['services_kz'] as List? ?? []),
    );
  }

  // ---------------------------------------------------------------------------
  // Model → Entity (с учётом локали)
  // ---------------------------------------------------------------------------

  TrustPointEntity toEntity(String locale) {
    final isKz = locale == 'kk';
    final coords = _coordinates[id];
    if (coords == null) {}
    return TrustPointEntity(
      id: id,
      title: isKz ? titleKz : titleRu,
      address: isKz ? addressKz : addressRu,
      hours: hours,
      services: isKz ? servicesKz : servicesRu,
      category: _categoryById(id),
      location: _coordinates[id] ?? const LatLng(43.2565, 76.9286),
    );
  }

  // ---------------------------------------------------------------------------
  // Вспомогательные методы
  // ---------------------------------------------------------------------------

  static TrustPointCategory _categoryById(String id) {
    if (id == 'almaty_aids_center') return TrustPointCategory.aidsCenter;
    if (id == 'gkv d' || id == 'gkvd') {
      return TrustPointCategory.dermatoVenerologic;
    }
    return TrustPointCategory.polyclinic;
  }

  /// Координаты по id документа Firestore.
  /// Взяты из Google Maps по адресам учреждений.
  static const Map<String, LatLng> _coordinates = {
    'gp2': LatLng(43.2700, 76.9728),      // ул. Шухова, 37а, Медеуский р-н
    'gp4': LatLng(43.2148, 76.8748),      // мкр. Орбита-3, 12а, Бостандыкский
    'gp5': LatLng(43.2435, 76.9568),      // ул. Макатаева, 141, Алмалинский
    'gp7': LatLng(43.2340, 76.9143),      // ул. Бухар Жырау, 14, Бостандыкский
    'gp8': LatLng(43.2592, 76.9610),      // ул. Туркебаева, 40, Алмалинский
    'gp9_trust': LatLng(43.3018, 76.9833), // ул. Шолохова, 17, Турксибский
    'gp9_spec': LatLng(43.3018, 76.9833),  // то же здание, другой блок услуг
    'gp10': LatLng(43.2512, 76.8322),     // мкр. Аксай-4, 17, Ауэзовский
    'gp11': LatLng(43.3348, 77.0240),     // мкр. Айнабулак-3, Жетысуский
    'gp23': LatLng(43.2788, 76.7735),     // мкр. Улжан-1, Алатауский
    'gp36': LatLng(43.2018, 76.7665),     // мкр. Шугыла, 340а, Наурызбайский
    'gkv d': LatLng(43.2353, 76.9238),    // ул. Манаса, 65, Бостандыкский
    'almaty_aids_center': LatLng(43.2382, 76.9215), // ул. Басенова, 2к4
  };
}