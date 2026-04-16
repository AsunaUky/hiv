import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/locale/locale_cubit.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/features/app/bloc/app_bloc.dart';
import 'package:hiv/features/home/ui/profile/guest_profile_screen.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_user == null || _user!.isAnonymous) {
      return const GuestProfileScreen();
    }

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go(RouteNames.login);
          });
        }
        if (state is AuthDeleteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ));
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ));
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

              _SectionLabel(label: l10n.profileLanguage),
              const _LanguageTile(),
              const SizedBox(height: 16),

              _SectionLabel(label: l10n.profileAccount),
              _MenuTile(
                icon: Icons.edit_outlined,
                label: l10n.profileEdit,
                onTap: () => context.push(RouteNames.editProfile),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _MenuTile(
                icon: Icons.logout_rounded,
                label: l10n.profileSignOut,
                onTap: () => _confirmSignOut(context, l10n),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _MenuTile(
                icon: Icons.delete_outline_rounded,
                label: l10n.profileDeleteAccount,
                color: AppColors.error,
                onTap: () => _confirmDelete(context, l10n),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.authSignOutTitle),
        content: Text(l10n.authSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.authCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.profileSignOut,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AppBloc>().add(const AuthSignOutRequested());
    }
  }

  Future<void> _confirmDelete(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.authDeleteTitle),
        content: Text(l10n.authDeleteWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.authCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.authDeleteConfirmBtn,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AppBloc>().add(const AuthDeleteRequested());
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final photoUrl = user?.photoURL;
    final name = user?.displayName ?? '';
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
          name.isNotEmpty ? name : l10n.profileGuest,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(email,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
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
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textHint, size: 20),
      onTap: onTap,
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();
  @override
  Widget build(BuildContext context) {
    final isKazakh = context.watch<LocaleCubit>().state.languageCode == 'kk';
    return Row(children: [
      _LangButton(
        label: 'Русский',
        selected: !isKazakh,
        onTap: () => context.read<LocaleCubit>().setLocale(const Locale('ru')),
      ),
      _LangButton(
        label: 'Қазақша',
        selected: isKazakh,
        onTap: () => context.read<LocaleCubit>().setLocale(const Locale('kk')),
      ),
    ]);
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
  Widget build(BuildContext context) => Expanded(
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