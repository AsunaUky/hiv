import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/features/app/bloc/app_bloc.dart';
import 'package:hiv/ui_kit/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _obscure    = true;
  bool _obscure2   = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AppBloc>().add(AuthRegisterRequested(
      name:     _nameCtrl.text,
      email:    _emailCtrl.text,
      password: _passCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AuthSuccess) context.go(RouteNames.home);
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  _RegHeader(),

                  const SizedBox(height: 36),

                  // Имя
                  AppTextField(
                    controller: _nameCtrl,
                    hint: 'Ваше имя',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 14),

                  // Email
                  AppTextField(
                    controller: _emailCtrl,
                    hint: 'Email',
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Введите email';
                      if (!v.contains('@')) return 'Некорректный email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Пароль
                  AppTextField(
                    controller: _passCtrl,
                    hint: 'Пароль',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _obscure,
                    suffixIcon: _EyeToggle(
                      obscure: _obscure,
                      onTap: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Минимум 6 символов' : null,
                  ),
                  const SizedBox(height: 14),

                  // Подтверждение пароля
                  AppTextField(
                    controller: _pass2Ctrl,
                    hint: 'Повторите пароль',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _obscure2,
                    suffixIcon: _EyeToggle(
                      obscure: _obscure2,
                      onTap: () => setState(() => _obscure2 = !_obscure2),
                    ),
                    validator: (v) =>
                        v != _passCtrl.text ? 'Пароли не совпадают' : null,
                  ),
                  const SizedBox(height: 28),

                  // Зарегистрироваться
                  BlocBuilder<AppBloc, AppState>(
                    builder: (_, state) => ElevatedButton(
                      onPressed: state is AuthLoading ? null : _submit,
                      child: state is AuthLoading
                          ? const _LoadingIndicator()
                          : const Text('Зарегистрироваться'),
                    ),
                  ),
                  const SizedBox(height: 32),

                  AuthBottomLink(
                    text: 'Уже есть аккаунт?',
                    linkText: 'Войти',
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Вспомогательные ─────────────────────────────────────────────

class _RegHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.health_and_safety_outlined,
              color: Colors.white, size: 24),
        ),
        const SizedBox(height: 24),
        const Text(
          'Регистрация',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Создайте аккаунт для доступа ко всем функциям',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
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
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.textHint,
        size: 20,
      ),
      onPressed: onTap,
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
    );
  }
}