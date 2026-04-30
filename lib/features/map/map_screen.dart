// lib/screens/map_screen.dart
// =============================================================================
// Главный экран карты — «Пункты доверия» г. Алматы.
// =============================================================================
//
// Архитектура экрана:
//   • FlutterMap (flutter_map ^8.3.0) — «холст» карты.
//   • TileLayer — тайлы OpenStreetMap.
//   • MarkerLayer — маркеры для каждой точки из [mockPlaces].
//   • Stack поверх карты — карточка с детальной информацией ([PlaceDetailsCard]).
//   • setState — управление выбранной точкой.
// =============================================================================
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hiv/data/datasources/trust_points_datasource.dart';
import 'package:hiv/data/models/trust_point_entity.dart';
import 'package:hiv/features/map/widgets/trust_point_card.dart';
import 'package:latlong2/latlong.dart';

/// Экран карты «Пунктов доверия».
///
/// [StatefulWidget]: нам нужно хранить выбранную точку [_selectedPlace]
/// и перестраивать UI при её изменении через [setState].
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ---------------------------------------------------------------------------
  // 1. Контроллер карты
  // ---------------------------------------------------------------------------
  // Позволяет программно двигать камеру: при тапе на маркер центрируемся
  // на нём. Создаётся один раз в [initState], освобождается в [dispose].
  late final MapController _mapController;

  // ---------------------------------------------------------------------------
  // 2. Текущая выбранная точка
  // ---------------------------------------------------------------------------
  // null → карточка скрыта; non-null → карточка показана для этой точки.
  Place? _selectedPlace;

  // ---------------------------------------------------------------------------
  // 3. Начальная позиция камеры
  // ---------------------------------------------------------------------------
  // Центр Алматы — все 12 точек умещаются при зуме ~10.5.
  static const _initialCenter = LatLng(43.2565, 76.9286);
  static const _initialZoom = 10.5;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Хендлеры
  // ---------------------------------------------------------------------------

  /// Тап по маркеру: запоминаем точку и плавно центрируемся на ней.
  void _onMarkerTap(Place place) {
    setState(() => _selectedPlace = place);
    // Зум 14 при выборе точки — достаточно, чтобы увидеть улицу.
    _mapController.move(place.location, 14.0);
  }

  /// Закрытие карточки (крестик или тап по пустому месту карты).
  void _closeDetails() {
    setState(() => _selectedPlace = null);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text('Пункты доверия'),
        centerTitle: true,
        actions: [
          // Счётчик всех точек — быстрая справка для пользователя.
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${mockPlaces.length} точек',
                style: TextStyle(
                  color: colorScheme.onPrimary.withValues(alpha: 0.85),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Слой 1: карта ─────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _initialZoom,
              minZoom: 3,
              maxZoom: 18,
              // Тап по пустому месту закрывает карточку.
              onTap: (_, _) => _closeDetails(),
            ),
            children: [
              // Тайловый слой OpenStreetMap.
              // В продакшене замените на коммерческого провайдера
              // (Mapbox / MapTiler / Stadia Maps), иначе нарушите политику OSM.
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.trust_points_map',
                maxZoom: 18,
              ),

              // Слой маркеров.
              MarkerLayer(
                markers: [
                  for (final place in mockPlaces)
                    Marker(
                      point: place.location,
                      width: 48,
                      height: 48,
                      // Якорь внизу: остриё маркера точно указывает на координату.
                      alignment: Alignment.bottomCenter,
                      child: _MarkerPin(
                        place: place,
                        isSelected: _selectedPlace?.id == place.id,
                        onTap: () => _onMarkerTap(place),
                      ),
                    ),
                ],
              ),

              // Обязательная атрибуция OSM (требование лицензии ODbL).
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // ── Слой 2: легенда категорий (верхний левый угол) ────────────────
          Positioned(top: 12, left: 12, child: _Legend()),

          // ── Слой 3: карточка деталей снизу ────────────────────────────────
          //
          // AnimatedSwitcher даёт плавное появление / исчезновение.
          // ValueKey по id необходим: без него AnimatedSwitcher не поймёт,
          // что один Place сменился другим, и не запустит анимацию.
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                final slide =
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );
                return SlideTransition(
                  position: slide,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _selectedPlace == null
                  ? const SizedBox.shrink(key: ValueKey('empty'))
                  : PlaceDetailsCard(
                      key: ValueKey(_selectedPlace!.id),
                      place: _selectedPlace!,
                      onClose: _closeDetails,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _MarkerPin — один маркер на карте
// =============================================================================

/// Визуальный виджет маркера.
///
/// Вынесен в отдельный [StatelessWidget], чтобы Flutter мог эффективно
/// перерисовывать только изменившиеся маркеры, а не весь экран.
class _MarkerPin extends StatelessWidget {
  final Place place;
  final bool isSelected;
  final VoidCallback onTap;

  const _MarkerPin({
    required this.place,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(place.category);

    return GestureDetector(
      // opaque: тап регистрируется даже в прозрачных областях виджета.
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Пузырь с иконкой.
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.85),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
              ),
              child: Icon(
                _iconFor(place.category),
                color: Colors.white,
                size: 18,
              ),
            ),
            // Острие (треугольник) под пузырём.
            CustomPaint(
              size: const Size(10, 6),
              painter: _PinTailPainter(color: color),
            ),
          ],
        ),
      ),
    );
  }

  static Color _colorFor(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.polyclinic:
        return const Color(0xFF1976D2); // Material Blue 700
      case PlaceCategory.dermatoVenerologic:
        return const Color(0xFF7B1FA2); // Material Purple 700
      case PlaceCategory.aidsCenter:
        return const Color(0xFFC62828); // Material Red 800
    }
  }

  static IconData _iconFor(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.polyclinic:
        return Icons.local_hospital_outlined;
      case PlaceCategory.dermatoVenerologic:
        return Icons.medical_services_outlined;
      case PlaceCategory.aidsCenter:
        return Icons.health_and_safety_outlined;
    }
  }
}

// =============================================================================
// _PinTailPainter — рисует острие маркера
// =============================================================================

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color;
}

// =============================================================================
// _Legend — легенда категорий (левый верхний угол)
// =============================================================================

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LegendItem(color: Color(0xFF1976D2), label: 'Поликлиника'),
          SizedBox(height: 4),
          _LegendItem(color: Color(0xFF7B1FA2), label: 'Кожвендиспансер'),
          SizedBox(height: 4),
          _LegendItem(color: Color(0xFFC62828), label: 'Центр СПИД'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
