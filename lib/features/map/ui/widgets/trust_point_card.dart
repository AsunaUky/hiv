import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/trust_points_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
extension _ContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Карточка детальной информации о «Пункте доверия».
///
/// Выезжает снизу через AnimatedSwitcher + SlideTransition в MapScreen.
/// Ничего не знает о карте — принимает готовый [TrustPointEntity].
class TrustPointCard extends StatelessWidget {
  const TrustPointCard({
    super.key,
    required this.point,
    required this.onClose,
    required this.onOpenRoute,
  });

  final TrustPointEntity point;
  final VoidCallback onClose;
  final VoidCallback onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final accentColor = _color(point.category);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.58,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 16, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // «Ручка» bottom sheet.
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Заголовок ───────────────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              accentColor.withValues(alpha: 0.12),
                          foregroundColor: accentColor,
                          child:
                              Icon(_icon(point.category), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                point.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              _IconText(
                                icon: Icons.place_outlined,
                                text: point.address,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: l10n.close,
                          onPressed: onClose,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 36, minHeight: 36),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── Режим работы ────────────────────────────────────────
                    _IconText(
                      icon: Icons.access_time_outlined,
                      text: '${l10n.mapHoursLabel}: ${point.hours}',
                      color: colorScheme.onSurface,
                      bold: true,
                    ),

                    const SizedBox(height: 12),

                    // ── Услуги ──────────────────────────────────────────────
                    Text(
                      l10n.mapServicesLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final s in point.services)
                          _ServiceChip(label: s, color: accentColor),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ── Кнопка маршрута ─────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.directions_outlined),
                        label: Text(l10n.mapRouteButton),
                        onPressed: onOpenRoute,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}

// ── Вспомогательные виджеты ───────────────────────────────────────────────────
class _IconText extends StatelessWidget {
  const _IconText({
    required this.icon,
    required this.text,
    required this.color,
    this.bold = false,
  });

  final IconData icon;
  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: bold ? FontWeight.w600 : null,
                ),
          ),
        ),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color),
      ),
    );
  }
}