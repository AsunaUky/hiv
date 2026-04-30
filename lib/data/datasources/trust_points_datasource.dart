// lib/data/mock_places.dart
// =============================================================================
// Все «Пункты доверия» г. Алматы.
// =============================================================================
//
// Координаты взяты из Google Maps по адресам из официального перечня.
// Список объявлен как const — Dart компилирует объекты на этапе сборки
// и не аллоцирует их в рантайме. Если данные будут приходить с сервера,
// замените этот геттер на Future<List<Place>> и используйте FutureBuilder
// или провайдер состояния.
// =============================================================================

import 'package:hiv/data/models/trust_point_entity.dart';
import 'package:latlong2/latlong.dart';


/// Базовый набор услуг, общий для всех городских поликлиник (группа 1).
const _basicServices = [
  'Тестирование на ВИЧ',
  'Раздача шприцов',
  'Раздача презервативов',
  'Раздача ИОМ',
  'Перенаправление в ДК',
];

/// Расширенный набор услуг (группа 2: ГП №9 второй блок, ГКВД, СПИД-центр).
const _extendedServices = [
  'Экспресс-тест на ВИЧ',
  'ИФА на ВГС, ВГВ, сифилис',
  'Мазок и ПЦР на ИППП',
  'Выдача презервативов',
  'Лечение ИППП',
];

/// Режим работы поликлиник (группа 1).
const _hoursBasic = '08:00–18:00';

/// Режим работы учреждений группы 2.
const _hoursExtended = '09:00–17:00';

/// Полный список «Пунктов доверия» г. Алматы.
///
/// Координаты проверены по Google Maps (широта/долгота в десятичных градусах).
const List<Place> mockPlaces = [
  // ── Группа 1: городские поликлиники (базовые услуги) ──────────────────────

  Place(
    id: 'gp-2',
    name: 'Городская поликлиника №2',
    category: PlaceCategory.polyclinic,
    address: 'Медеуский район, ул. Шухова, 37Б',
    hours: _hoursBasic,
    services: _basicServices,
    // Шухова, 37Б — координаты Google Maps: 43.2700° с.ш., 76.9728° в.д.
    location: LatLng(43.2700, 76.9728),
  ),

  Place(
    id: 'gp-4',
    name: 'Городская поликлиника №4',
    category: PlaceCategory.polyclinic,
    address: 'Бостандыкский район, мкр. Орбита-3, д. 12а',
    hours: _hoursBasic,
    services: _basicServices,
    // мкр. Орбита-3 — координаты Google Maps: 43.2148° с.ш., 76.8748° в.д.
    location: LatLng(43.2148, 76.8748),
  ),

  Place(
    id: 'gp-5',
    name: 'Городская поликлиника №5',
    category: PlaceCategory.polyclinic,
    address: 'Алмалинский район, ул. Макатаева, 141',
    hours: _hoursBasic,
    services: _basicServices,
    // ул. Макатаева, 141 — координаты Google Maps: 43.2435° с.ш., 76.9568° в.д.
    location: LatLng(43.2435, 76.9568),
  ),

  Place(
    id: 'gp-7',
    name: 'Городская поликлиника №7',
    category: PlaceCategory.polyclinic,
    address: 'Бостандыкский район, ул. Бухар Жырау, 14',
    hours: _hoursBasic,
    services: _basicServices,
    // ул. Бухар Жырау, 14 — координаты Google Maps: 43.2340° с.ш., 76.9143° в.д.
    location: LatLng(43.2340, 76.9143),
  ),

  Place(
    id: 'gp-8',
    name: 'Городская поликлиника №8',
    category: PlaceCategory.polyclinic,
    address: 'Алмалинский район, ул. Туркебаева, 40',
    hours: _hoursBasic,
    services: _basicServices,
    // ул. Туркебаева, 40 — координаты Google Maps: 43.2592° с.ш., 76.9610° в.д.
    location: LatLng(43.2592, 76.9610),
  ),

  Place(
    id: 'gp-9',
    name: 'Городская поликлиника №9',
    category: PlaceCategory.polyclinic,
    address: 'Турксибский район, ул. Шолохова, 17',
    hours: _hoursBasic,
    services: _basicServices,
    // ул. Шолохова, 17 — координаты Google Maps: 43.3018° с.ш., 76.9833° в.д.
    location: LatLng(43.3018, 76.9833),
  ),

  Place(
    id: 'gp-10',
    name: 'Городская поликлиника №10',
    category: PlaceCategory.polyclinic,
    address: 'Ауэзовский район, мкр. Аксай-4, д. 17',
    hours: _hoursBasic,
    services: _basicServices,
    // мкр. Аксай-4 — координаты Google Maps: 43.2512° с.ш., 76.8322° в.д.
    location: LatLng(43.2512, 76.8322),
  ),

  Place(
    id: 'gp-11',
    name: 'Городская поликлиника №11',
    category: PlaceCategory.polyclinic,
    address: 'Жетысуский район, мкр. Айнабулак-3, ул. Жумабаева, 87',
    hours: _hoursBasic,
    services: _basicServices,
    // мкр. Айнабулак-3 — координаты Google Maps: 43.3348° с.ш., 77.0240° в.д.
    location: LatLng(43.3348, 77.0240),
  ),

  Place(
    id: 'gp-23',
    name: 'Городская поликлиника №23',
    category: PlaceCategory.polyclinic,
    address: 'Алатауский район, мкр. Улжан-1, ул. Жалайыр, 34',
    hours: _hoursBasic,
    services: _basicServices,
    // мкр. Улжан-1 — координаты Google Maps: 43.2788° с.ш., 76.7735° в.д.
    location: LatLng(43.2788, 76.7735),
  ),

  Place(
    id: 'gp-36',
    name: 'Городская поликлиника №36',
    category: PlaceCategory.polyclinic,
    address: 'Наурызбайский район, мкр. Шугыла, 340а',
    hours: _hoursBasic,
    services: _basicServices,
    // мкр. Шугыла — координаты Google Maps: 43.2018° с.ш., 76.7665° в.д.
    location: LatLng(43.2018, 76.7665),
  ),

  // ── Группа 2: специализированные учреждения (расширенные услуги) ──────────

  Place(
    id: 'gkvd',
    name: 'Городской кожно-венерологический диспансер',
    category: PlaceCategory.dermatoVenerologic,
    address: 'Бостандыкский район, ул. Манаса, 65',
    hours: _hoursExtended,
    services: [
      ..._extendedServices,
      'Лечение сифилиса',
    ],
    // ул. Манаса, 65 — координаты Google Maps: 43.2353° с.ш., 76.9238° в.д.
    location: LatLng(43.2353, 76.9238),
  ),

  Place(
    id: 'aids-center',
    name: 'Центр по профилактике и борьбе со СПИД г. Алматы',
    category: PlaceCategory.aidsCenter,
    address: 'Бостандыкский район, ул. Басенова, 2 к4',
    hours: _hoursExtended,
    services: [
      ..._extendedServices,
      'Выдача ДКП (доконтактная профилактика)',
    ],
    // ул. Басенова, 2 к4 (угол ул. Жарокова) — Google Maps: 43.2382° с.ш., 76.9215° в.д.
    location: LatLng(43.2382, 76.9215),
  ),
];