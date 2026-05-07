import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/core/utils/validator.dart';
import 'package:hiv/features/app/bloc/app_bloc.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';
import 'package:hiv/ui_kit/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure    = true;

  // FIX: если текущий пользователь — гость (анонимный),
  // кнопка «Войти как гость» бессмысленна — скрываем её.
  bool get _isGuest =>
      FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AppBloc>().add(AuthSignInRequested(
      email:    _emailCtrl.text,
      password: _passCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AuthSuccess) context.go(RouteNames.main);
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Scaffold(
        appBar: context.canPop()
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary, size: 20),
                  onPressed: () => context.pop(),
                ),
              )
            : null,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Верхний блок: поля по центру ─────────────────
                // LayoutBuilder даёт реальную высоту Expanded,
                // ConstrainedBox растягивает Column до этой высоты,
                // mainAxisAlignment: center — поля по середине.
                // SingleChildScrollView включается когда клавиатура
                // поднимается и места становится меньше.
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 28),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _AuthHeader(
                              title: 'Вход',
                              subtitle: 'Добро пожаловать',
                            ),
                            const SizedBox(height: 32),
                            AppTextField(
                              controller: _emailCtrl,
                              hint: 'Email',
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => AppValidators.email(value, AppLocalizations.of(context)),
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              controller: _passCtrl,
                              hint: 'Пароль',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscure,
                              suffixIcon: _EyeToggle(
                                obscure: _obscure,
                                onTap: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              validator: (value) => AppValidators.loginPassword(value, AppLocalizations.of(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // ── Нижний блок: кнопки всегда внизу ─────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<AppBloc, AppState>(
                        builder: (_, state) => ElevatedButton(
                          onPressed:
                              state is AuthLoading ? null : _submit,
                          child: state is AuthLoading
                              ? const _Spinner()
                              : const Text('Войти'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<AppBloc, AppState>(
                        builder: (context, state) => GoogleSignInButton(
                          loading: state is AuthLoading,
                          onTap: () => context
                              .read<AppBloc>()
                              .add(const AuthGoogleRequested()),
                        ),
                      ),
                      // Кнопка «Войти как гость» скрыта, если пользователь
                      // уже является гостем — ему она не нужна.
                      if (!_isGuest) ...[
                        const SizedBox(height: 10),
                        BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) =>
                              OutlinedButton.icon(
                            onPressed: state is AuthLoading
                                ? null
                                : () => context
                                    .read<AppBloc>()
                                    .add(const AuthGuestRequested()),
                            icon: const Icon(
                                Icons.person_outline_rounded,
                                size: 18),
                            label: const Text('Войти как гость'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: const BorderSide(
                                  color: AppColors.divider),
                              minimumSize:
                                  const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      AuthBottomLink(
                        text: 'Нет аккаунта?',
                        linkText: 'Зарегистрироваться',
                        onTap: () =>
                            context.pushReplacement(RouteNames.register),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/icons/app_icon.png',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        Text(title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            )),
        const SizedBox(height: 6),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 15, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _EyeToggle extends StatelessWidget {
  const _EyeToggle({required this.obscure, required this.onTap});
  final bool obscure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        obscure
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: AppColors.textHint,
        size: 20,
      ),
      onPressed: onTap,
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
          color: Colors.white, strokeWidth: 2.5),
    );
  }
}