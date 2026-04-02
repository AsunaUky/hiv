import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/services/language_service.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/features/app/bloc/app_bloc.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isKazakh = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    LanguageService.load().then((val) {
      if (mounted) setState(() => _isKazakh = val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        // Выход или удаление — идём на логин
        if (state is AuthInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go(RouteNames.login);
          });
        }

        // Ошибка удаления — требуется повторный вход
        if (state is AuthDeleteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Общая ошибка
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 32),
              _ProfileHeader(user: _user),
              const SizedBox(height: 32),

              _SectionLabel(label: _isKazakh ? 'Тіл' : 'Язык'),
              _LanguageTile(
                isKazakh: _isKazakh,
                onChanged: (val) {
                  setState(() => _isKazakh = val);
                  LanguageService.save(val);
                },
              ),
              const SizedBox(height: 16),

              _SectionLabel(label: 'Аккаунт'),
              _MenuTile(
                icon: Icons.edit_outlined,
                label: _isKazakh ? 'Профильді өзгерту' : 'Редактировать профиль',
                onTap: () => context.push(RouteNames.editProfile),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _MenuTile(
                icon: Icons.logout_rounded,
                label: _isKazakh ? 'Шығу' : 'Выйти',
                onTap: () => _confirmSignOut(context),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _MenuTile(
                icon: Icons.delete_outline_rounded,
                label: _isKazakh ? 'Аккаунтты жою' : 'Удалить аккаунт',
                color: AppColors.error,
                onTap: () => _confirmDelete(context),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: Text(_isKazakh ? 'Шығу' : 'Выйти'),
        content: Text(
          _isKazakh
              ? 'Аккаунттан шыққыңыз келе ме?'
              : 'Вы уверены, что хотите выйти?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(_isKazakh ? 'Болдырмау' : 'Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              _isKazakh ? 'Шығу' : 'Выйти',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      // Через BLoC → AuthRepository → FirebaseAuthService (Firebase + Google)
      context.read<AppBloc>().add(const AuthSignOutRequested());
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: Text(_isKazakh ? 'Аккаунтты жою' : 'Удалить аккаунт'),
        content: Text(
          _isKazakh
              ? 'Бұл әрекетті кері қайтару мүмкін емес.'
              : 'Это действие необратимо. Все данные будут удалены.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(_isKazakh ? 'Болдырмау' : 'Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              _isKazakh ? 'Жою' : 'Удалить',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      // Через BLoC → AuthRepository → FirebaseAuthService
      context.read<AppBloc>().add(const AuthDeleteRequested());
    }
  }
}

// ─── Вспомогательные виджеты ─────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL;
    final name = user?.displayName ?? 'Пользователь';
    final email = user?.email ?? '';

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.primary,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ],
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
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: TextStyle(color: c, fontSize: 15)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textHint,
        size: 20,
      ),
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