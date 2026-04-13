import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/core/utils/validator.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.login);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RegHeader(),
                        const SizedBox(height: 28),
                        AppTextField(
                          controller: _nameCtrl,
                          hint: 'Ваше имя',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: AppValidators.name,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _emailCtrl,
                          hint: 'Email',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidators.email,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _passCtrl,
                          hint: 'Пароль',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscure,
                          suffixIcon: _EyeToggle(
                            obscure: _obscure,
                            onTap: () => setState(() => _obscure = !_obscure),
                          ),
                          validator: AppValidators.password,
                        ),
                        const SizedBox(height: 14),
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
                              AppValidators.confirmPassword(v, _passCtrl.text),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<AppBloc, AppState>(
                        builder: (_, state) => ElevatedButton(
                          onPressed: state is AuthLoading ? null : _submit,
                          child: state is AuthLoading
                              ? const _Spinner()
                              : const Text('Зарегистрироваться'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // pushReplacement: заменяет текущий экран в стеке,
                      // не добавляет новый. Сколько бы раз ни переключались
                      // login ↔ register — назад всегда один шаг до профиля.
                      AuthBottomLink(
                        text: 'Уже есть аккаунт?',
                        linkText: 'Войти',
                        onTap: () =>
                            context.pushReplacement(RouteNames.login),
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
        const SizedBox(height: 20),
        const Text('Регистрация',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            )),
        const SizedBox(height: 6),
        const Text('Создайте аккаунт для доступа ко всем функциям',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
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

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
    );
  }
}