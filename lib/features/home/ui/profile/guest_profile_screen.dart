import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/locale/locale_cubit.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 32),

            // Аватар + имя
            Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.divider,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 48,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.profileGuest,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            _buildSectionTitle(l10n.profileLanguage),
            const SizedBox(height: 12),
            const _LanguageSelector(),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => context.push(RouteNames.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.authSignIn,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textHint,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final isKazakh = currentLocale.languageCode == 'kk';

    return Row(
      children: [
        _LangButton(
          label: 'Русский',
          selected: !isKazakh,
          onTap: () =>
              context.read<LocaleCubit>().setLocale(const Locale('ru')),
        ),
        _LangButton(
          label: 'Қазақша',
          selected: isKazakh,
          onTap: () =>
              context.read<LocaleCubit>().setLocale(const Locale('kk')),
        ),
      ],
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}