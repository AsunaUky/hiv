import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/services/language_service.dart';
import 'package:hiv/core/theme/app_colors.dart';

/// Профиль гостя — показывается когда user.isAnonymous == true.
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Аватар-заглушка
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.divider,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 48,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                _isKazakh ? 'Қонақ' : 'Гость',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isKazakh
                    ? 'Барлық мүмкіндіктерді пайдалану үшін тіркеліңіз'
                    : 'Зарегистрируйтесь для доступа ко всем функциям',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // Зарегистрироваться
              ElevatedButton(
                onPressed: () => context.push(RouteNames.register),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(_isKazakh ? 'Тіркелу' : 'Зарегистрироваться'),
              ),
              const SizedBox(height: 12),

              // Войти
              OutlinedButton(
                onPressed: () => context.push(RouteNames.login),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(_isKazakh ? 'Кіру' : 'Войти'),
              ),

              const Spacer(),

              // Переключатель языка внизу
              _LanguageTile(
                isKazakh: _isKazakh,
                onChanged: (val) {
                  setState(() => _isKazakh = val);
                  LanguageService.save(val);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
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
            onTap: () => onChanged(false),
          ),
          _LangButton(
            label: 'Қазақша',
            selected: isKazakh,
            onTap: () => onChanged(true),
          ),
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