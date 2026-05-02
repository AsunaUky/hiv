import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hiv/features/map/bloc/trust_points_cubit.dart';
import 'package:hiv/features/map/bloc/trust_points_state.dart';
import 'package:hiv/features/map/ui/widgets/trust_point_card.dart';
import 'package:latlong2/latlong.dart' hide Path; // скрываем Path из latlong2
import 'package:url_launcher/url_launcher.dart';

import '../../../core/locale/locale_cubit.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/trust_points_entity.dart';
import '../../../l10n/generated/app_localizations.dart';

extension _L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  TrustPointEntity? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    final locale = context.read<LocaleCubit>().state.languageCode;
    context.read<TrustPointsCubit>().load(locale);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // ── Геолокация ─────────────────────────────────────────────────────────────

  Future<void> _onFindMeTapped() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final permService = PermissionService();

    // Проверяем без диалога — если уже выдано, не тревожим пользователя.
    final alreadyGranted = await permService.isLocationGranted();
    if (!alreadyGranted) {
      final granted = await permService.requestLocation(uid);
      if (!granted) return; // отказал или открыли настройки
    }

    try {
      // Timeout 10 сек — без него на некоторых устройствах висит бесконечно.
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (mounted) {
        _mapController.move(LatLng(pos.latitude, pos.longitude), 15.0);
      }
    } on LocationServiceDisabledException {
      // GPS выключен на устройстве.
      if (mounted) {
        _showSnackBar(context.l10n.mapLocationGpsOff);
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(context.l10n.mapLocationError);
      }
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  // ── Маршрут: 2ГИС → веб-версия 2ГИС → Google Maps ────────────────────────
  //
  // 2ГИС использует порядок: ДОЛГОТА,ШИРОТА (lng,lat) — это важно!
  //
  // Порядок попыток:
  //   1. dgis:// — приложение 2ГИС (если установлено)
  //   2. https://2gis.kz/routeto — веб-версия 2ГИС (всегда работает)
  //   3. Google Maps — абсолютный fallback
  //
  // Для Android 11+ нужно добавить в AndroidManifest.xml (см. комментарий
  // в конце файла) — иначе canLaunchUrl для dgis:// всегда вернёт false.

  static Future<void> _openRoute(double lat, double lng) async {
    // 1. Приложение 2ГИС (deep link).
    final twoGisApp = Uri.parse(
      'dgis://2gis.ru/routeTo?ll=$lng,$lat&type=pedestrian',
    );

    // 2. Веб-версия 2ГИС (работает без приложения, открывает в браузере).
    final twoGisWeb = Uri.parse(
      'https://2gis.kz/routeto?ll=$lng,$lat',
    );

    // 3. Google Maps (абсолютный fallback).
    final googleMaps = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    if (await canLaunchUrl(twoGisApp)) {
      await launchUrl(twoGisApp);
    } else if (await canLaunchUrl(twoGisWeb)) {
      await launchUrl(twoGisWeb, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(googleMaps, mode: LaunchMode.externalApplication);
    }
  }

  // ── State helpers ──────────────────────────────────────────────────────────

  void _onMarkerTap(TrustPointEntity point) {
    setState(() => _selectedPoint = point);
    _mapController.move(point.location, 14.0);
  }

  void _closeCard() => setState(() => _selectedPoint = null);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<LocaleCubit, Locale>(
      listener: (context, locale) {
        context.read<TrustPointsCubit>().changeLocale(locale.languageCode);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          title: Text(context.l10n.mapTitle),
          centerTitle: true,
        ),
        body: BlocBuilder<TrustPointsCubit, TrustPointsState>(
          builder: (context, state) => switch (state) {
            TrustPointsInitial() || TrustPointsLoading() =>
              const Center(child: CircularProgressIndicator()),
            TrustPointsError(:final message) => _ErrorView(
                message: message,
                onRetry: () {
                  final locale =
                      context.read<LocaleCubit>().state.languageCode;
                  context.read<TrustPointsCubit>().load(locale);
                },
              ),
            TrustPointsLoaded(:final points) => _MapBody(
                points: points,
                selectedPoint: _selectedPoint,
                mapController: _mapController,
                onMarkerTap: _onMarkerTap,
                onClose: _closeCard,
                onFindMe: _onFindMeTapped,
                onOpenRoute: _openRoute,
              ),
          },
        ),
      ),
    );
  }
}

// =============================================================================
// _MapBody
// =============================================================================

class _MapBody extends StatelessWidget {
  const _MapBody({
    required this.points,
    required this.selectedPoint,
    required this.mapController,
    required this.onMarkerTap,
    required this.onClose,
    required this.onFindMe,
    required this.onOpenRoute,
  });

  final List<TrustPointEntity> points;
  final TrustPointEntity? selectedPoint;
  final MapController mapController;
  final ValueChanged<TrustPointEntity> onMarkerTap;
  final VoidCallback onClose;
  final VoidCallback onFindMe;
  final Future<void> Function(double lat, double lng) onOpenRoute;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const LatLng(43.2565, 76.9286),
            initialZoom: 10.5,
            minZoom: 3,
            maxZoom: 18,
            onTap: (_, _) => onClose(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.hiv',
              maxZoom: 18,
            ),
            MarkerLayer(
              markers: [
                for (final p in points)
                  Marker(
                    point: p.location,
                    width: 48,
                    height: 48,
                    alignment: Alignment.bottomCenter,
                    child: _MarkerPin(
                      point: p,
                      isSelected: selectedPoint?.id == p.id,
                      onTap: () => onMarkerTap(p),
                    ),
                  ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('© OpenStreetMap contributors'),
              ],
            ),
          ],
        ),

        const Positioned(top: 12, left: 12, child: _Legend()),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          right: 12,
          bottom: selectedPoint != null ? 290 : 20,
          child: _FindMeButton(onTap: onFindMe),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: selectedPoint == null
                ? const SizedBox.shrink(key: ValueKey('empty'))
                : TrustPointCard(
                    key: ValueKey(selectedPoint!.id),
                    point: selectedPoint!,
                    onClose: onClose,
                    onOpenRoute: () => onOpenRoute(
                      selectedPoint!.location.latitude,
                      selectedPoint!.location.longitude,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// _MarkerPin
// =============================================================================

class _MarkerPin extends StatelessWidget {
  const _MarkerPin({
    required this.point,
    required this.isSelected,
    required this.onTap,
  });

  final TrustPointEntity point;
  final bool isSelected;
  final VoidCallback onTap;

  static Color _color(TrustPointCategory c) => switch (c) {
        TrustPointCategory.polyclinic => AppColors.trustPolyclinic,
        TrustPointCategory.dermatoVenerologic =>
          AppColors.trustDermatoVenerologic,
        TrustPointCategory.aidsCenter => AppColors.trustAidsCenter,
      };

  static IconData _icon(TrustPointCategory c) => switch (c) {
        TrustPointCategory.polyclinic => Icons.local_hospital_outlined,
        TrustPointCategory.dermatoVenerologic =>
          Icons.medical_services_outlined,
        TrustPointCategory.aidsCenter => Icons.health_and_safety_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final color = _color(point.category);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.85),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  Icon(_icon(point.category), color: Colors.white, size: 18),
            ),
            CustomPaint(
              size: const Size(10, 6),
              painter: _PinTail(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinTail extends CustomPainter {
  const _PinTail({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTail o) => o.color != color;
}

// =============================================================================
// _Legend / _LegendRow
// =============================================================================

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LegendRow(
              color: AppColors.trustPolyclinic,
              label: l10n.mapLegendPolyclinic),
          const SizedBox(height: 4),
          _LegendRow(
              color: AppColors.trustDermatoVenerologic,
              label: l10n.mapLegendDerma),
          const SizedBox(height: 4),
          _LegendRow(
              color: AppColors.trustAidsCenter,
              label: l10n.mapLegendAids),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});
  final Color color;
  final String label;

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

// =============================================================================
// _FindMeButton
// =============================================================================

class _FindMeButton extends StatelessWidget {
  const _FindMeButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'map_find_me',
      tooltip: context.l10n.mapFindMe,
      onPressed: onTap,
      child: const Icon(Icons.my_location_outlined),
    );
  }
}

// =============================================================================
// _ErrorView
// =============================================================================

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}