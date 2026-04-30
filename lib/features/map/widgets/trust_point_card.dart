// lib/widgets/place_details_card.dart
// =============================================================================
// Карточка с подробной информацией о выбранном «Пункте доверия».
// =============================================================================
//
// Показывается поверх карты (через Stack) при тапе на маркер.
// Ничего не знает про карту — принимает готовый [Place] и колбэк закрытия.
// Такая изоляция упрощает тестирование и переиспользование.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:hiv/data/models/trust_point_entity.dart';

/// Карточка детальной информации о «Пункте доверия».
///
/// Рендерится внутри [Stack] на экране карты и выезжает снизу
/// с анимацией [AnimatedSwitcher] + [SlideTransition].
class PlaceDetailsCard extends StatelessWidget {
  /// Данные точки, для которой показывается карточка.
  final Place place;

  /// Колбэк закрытия — логика «что делать при закрытии» живёт в MapScreen.
  final VoidCallback onClose;

  const PlaceDetailsCard({
    super.key,
    required this.place,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = _colorFor(place.category);

    return Container(
      // Ограничиваем высоту: максимум 60% экрана, остальное скроллится.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.60,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── «Ручка» для визуального намёка на bottom sheet ──────────────
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

            // ── Скроллируемое содержимое ─────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Заголовок: иконка + название + крестик ───────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Иконка категории в цветном круге.
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              categoryColor.withValues(alpha: 0.12),
                          foregroundColor: categoryColor,
                          child: Icon(_iconFor(place.category), size: 22),
                        ),
                        const SizedBox(width: 12),

                        // Название + адрес.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      place.address,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Кнопка закрытия.
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: 'Закрыть',
                          onPressed: onClose,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Режим работы ─────────────────────────────────────────
                    _InfoRow(
                      icon: Icons.access_time_outlined,
                      iconColor: categoryColor,
                      label: 'Режим работы',
                      value: place.hours,
                    ),

                    const SizedBox(height: 14),

                    // ── Тип учреждения ────────────────────────────────────────
                    _InfoRow(
                      icon: Icons.apartment_outlined,
                      iconColor: categoryColor,
                      label: 'Тип',
                      value: _categoryLabel(place.category),
                    ),

                    const SizedBox(height: 14),

                    // ── Услуги ────────────────────────────────────────────────
                    Text(
                      'Перечень услуг',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final service in place.services)
                          _ServiceChip(
                            label: service,
                            color: categoryColor,
                          ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ── Кнопка «Построить маршрут» ───────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.directions_outlined),
                        label: const Text('Построить маршрут'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Маршрут до «${place.name}» — '
                                'здесь будет интеграция с навигатором.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
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

  // ---------------------------------------------------------------------------
  // Хелперы категории
  // ---------------------------------------------------------------------------

  static Color _colorFor(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.polyclinic:
        return const Color(0xFF1976D2);
      case PlaceCategory.dermatoVenerologic:
        return const Color(0xFF7B1FA2);
      case PlaceCategory.aidsCenter:
        return const Color(0xFFC62828);
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

  static String _categoryLabel(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.polyclinic:
        return 'Городская поликлиника';
      case PlaceCategory.dermatoVenerologic:
        return 'Кожно-венерологический диспансер';
      case PlaceCategory.aidsCenter:
        return 'Центр профилактики и борьбы со СПИД';
    }
  }
}

// =============================================================================
// Вспомогательные виджеты (приватные)
// =============================================================================

/// Строка «иконка + заголовок: значение».
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Чип одной услуги.
class _ServiceChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ServiceChip({required this.label, required this.color});

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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}