import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiv/core/utils/validator.dart';
import 'package:hiv/features/home/ui/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiv/core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameKey    = GlobalKey<FormState>();
  final _emailKey   = GlobalKey<FormState>();
  final _passKey    = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  final _emailCtrl      = TextEditingController();
  final _emailPassCtrl  = TextEditingController();
  final _currPassCtrl   = TextEditingController();
  final _newPassCtrl    = TextEditingController();
  final _confPassCtrl   = TextEditingController();

  bool _obscureCurr  = true;
  bool _obscureNew   = true;
  bool _obscureConf  = true;
  bool _obscureEPass = true;

  File? _pickedImage;
  bool _uploadingPhoto = false;
  bool _savingName     = false;
  bool _savingEmail    = false;
  bool _savingPass     = false;

  User? get _user => FirebaseAuth.instance.currentUser;
  final _repo = UserRepository.instance;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _emailPassCtrl.dispose();
    _currPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    super.dispose();
  }

  // ── Фото ─────────────────────────────────────────────────────

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
    await _uploadPhoto();
  }

  Future<void> _uploadPhoto() async {
    if (_pickedImage == null) return;
    setState(() => _uploadingPhoto = true);
    try {
      await _repo.uploadPhoto(_pickedImage!);
      if (mounted) {
        _showSuccess('Фото обновлено');
        setState(() {}); // обновляем аватар
      }
    } catch (e) {
      if (mounted) _showError('Ошибка загрузки фото');
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  // ── Имя ───────────────────────────────────────────────────────

  Future<void> _saveName() async {
    if (!_nameKey.currentState!.validate()) return;
    setState(() => _savingName = true);
    try {
      await _repo.updateDisplayName(_nameCtrl.text);
      if (mounted) _showSuccess('Имя обновлено');
    } catch (_) {
      if (mounted) _showError('Ошибка обновления имени');
    } finally {
      if (mounted) setState(() => _savingName = false);
    }
  }

  // ── Email ─────────────────────────────────────────────────────

  Future<void> _saveEmail() async {
    if (!_emailKey.currentState!.validate()) return;
    setState(() => _savingEmail = true);
    try {
      await _repo.updateEmail(
        newEmail: _emailCtrl.text,
        password: _emailPassCtrl.text,
      );
      if (mounted) {
        _showSuccess('Письмо подтверждения отправлено на ${_emailCtrl.text}');
        _emailCtrl.clear();
        _emailPassCtrl.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _showError(_mapError(e.code));
    } catch (_) {
      if (mounted) _showError('Ошибка обновления email');
    } finally {
      if (mounted) setState(() => _savingEmail = false);
    }
  }

  // ── Пароль ────────────────────────────────────────────────────

  Future<void> _savePassword() async {
    if (!_passKey.currentState!.validate()) return;
    setState(() => _savingPass = true);
    try {
      await _repo.updatePassword(
        currentPassword: _currPassCtrl.text,
        newPassword: _newPassCtrl.text,
      );
      if (mounted) {
        _showSuccess('Пароль изменён');
        _currPassCtrl.clear();
        _newPassCtrl.clear();
        _confPassCtrl.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _showError(_mapError(e.code));
    } catch (_) {
      if (mounted) _showError('Ошибка смены пароля');
    } finally {
      if (mounted) setState(() => _savingPass = false);
    }
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
    ));
  }

  String _mapError(String code) => switch (code) {
        'wrong-password'         => 'Неверный пароль',
        'invalid-credential'     => 'Неверный пароль',
        'email-already-in-use'   => 'Email уже используется',
        'invalid-email'          => 'Некорректный email',
        'weak-password'          => 'Слишком простой пароль',
        'requires-recent-login'  => 'Выйдите и войдите снова',
        _                        => 'Ошибка: $code',
      };

  @override
  Widget build(BuildContext context) {
    final photoUrl = _user?.photoURL;
    final hasEmail = _user?.email != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // ── Фото ─────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.primary,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : (photoUrl != null
                              ? NetworkImage(photoUrl) as ImageProvider
                              : null),
                      child: (_pickedImage == null && photoUrl == null)
                          ? Text(
                              (_user?.displayName ?? '?')[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    if (_uploadingPhoto)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _uploadingPhoto ? null : _pickPhoto,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_outlined,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Имя ──────────────────────────────────────────
              _SectionLabel(label: 'Имя'),
              Form(
                key: _nameKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Field(
                      controller: _nameCtrl,
                      hint: 'Ваше имя',
                      icon: Icons.person_outline_rounded,
                      validator: AppValidators.name,
                    ),
                    const SizedBox(height: 10),
                    _SaveButton(
                      label: 'Сохранить имя',
                      loading: _savingName,
                      onTap: _saveName,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Email (только для email-пользователей) ────────
              if (hasEmail) ...[
                _SectionLabel(label: 'Email'),
                Form(
                  key: _emailKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Field(
                        controller: _emailCtrl,
                        hint: 'Новый email',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                      ),
                      const SizedBox(height: 10),
                      _PasswordField(
                        controller: _emailPassCtrl,
                        hint: 'Текущий пароль',
                        obscure: _obscureEPass,
                        onToggle: () =>
                            setState(() => _obscureEPass = !_obscureEPass),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Введите пароль' : null,
                      ),
                      const SizedBox(height: 10),
                      _SaveButton(
                        label: 'Изменить email',
                        loading: _savingEmail,
                        onTap: _saveEmail,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'На новый адрес придёт письмо для подтверждения',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Пароль ────────────────────────────────────
                _SectionLabel(label: 'Пароль'),
                Form(
                  key: _passKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PasswordField(
                        controller: _currPassCtrl,
                        hint: 'Текущий пароль',
                        obscure: _obscureCurr,
                        onToggle: () =>
                            setState(() => _obscureCurr = !_obscureCurr),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Введите пароль' : null,
                      ),
                      const SizedBox(height: 10),
                      _PasswordField(
                        controller: _newPassCtrl,
                        hint: 'Новый пароль',
                        obscure: _obscureNew,
                        onToggle: () =>
                            setState(() => _obscureNew = !_obscureNew),
                        validator: AppValidators.password,
                      ),
                      const SizedBox(height: 10),
                      _PasswordField(
                        controller: _confPassCtrl,
                        hint: 'Повторите новый пароль',
                        obscure: _obscureConf,
                        onToggle: () =>
                            setState(() => _obscureConf = !_obscureConf),
                        validator: (v) => AppValidators.confirmPassword(
                            v, _newPassCtrl.text),
                      ),
                      const SizedBox(height: 10),
                      _SaveButton(
                        label: 'Изменить пароль',
                        loading: _savingPass,
                        onTap: _savePassword,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Вспомогательные виджеты ─────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIcon: const Icon(Icons.lock_outline_rounded,
            color: AppColors.textHint, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textHint,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onTap,
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
          : Text(label),
    );
  }
}