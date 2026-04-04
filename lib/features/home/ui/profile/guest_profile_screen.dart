import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/services/language_service.dart';
import 'package:hiv/core/theme/app_colors.dart';

class GuestProfileScreen extends StatefulWidget {
  const GuestProfileScreen({super.key});

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  bool _isKazakh = false;

  @override
  void initState() {
    super.initState();
    LanguageService.load().then((val) {
      if (mounted) setState(() => _isKazakh = val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 32),

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
                  _isKazakh ? 'Қонақ' : 'Гость',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isKazakh
                      ? 'Барлық мүмкіндіктерді ашу үшін кіріңіз'
                      : 'Войдите, чтобы открыть все возможности',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _SectionLabel(label: _isKazakh ? 'Аккаунт' : 'Аккаунт'),
            _MenuTile(
              icon: Icons.login_rounded,
              label: _isKazakh ? 'Кіру' : 'Войти',
              // go() заменяет текущий маршрут — выходим из ShellRoute корректно
              onTap: () => context.go(RouteNames.login),
            ),
            const Divider(color: AppColors.divider, height: 1),
            _MenuTile(
              icon: Icons.person_add_outlined,
              label: _isKazakh ? 'Тіркелу' : 'Зарегистрироваться',
              onTap: () => context.go(RouteNames.register),
            ),

            const SizedBox(height: 16),

            _SectionLabel(label: _isKazakh ? 'Тіл' : 'Язык'),
            _LanguageTile(
              isKazakh: _isKazakh,
              onChanged: (val) {
                setState(() => _isKazakh = val);
                LanguageService.save(val);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textHint,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(label,
          style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textHint, size: 20),
      onTap: onTap,
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.isKazakh, required this.onChanged});
  final bool isKazakh;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _LangButton(
              label: 'Русский',
              selected: !isKazakh,
              onTap: () => onChanged(false)),
          _LangButton(
              label: 'Қазақша',
              selected: isKazakh,
              onTap: () => onChanged(true)),
        ],
      ),
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
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}