import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiv/features/home/ui/profile/edit/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/core/utils/validator.dart';

/// Редактирование профиля — фото, имя и пароль. Одна кнопка «Сохранить».
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  final _currPassCtrl = TextEditingController();
  final _newPassCtrl  = TextEditingController();
  final _confPassCtrl = TextEditingController();

  bool _obscureCurr = true;
  bool _obscureNew  = true;
  bool _obscureConf = true;

  File? _pickedImage;
  bool _saving         = false;
  bool _uploadingPhoto = false;

  bool _changePassword = false;

  User? get _user => FirebaseAuth.instance.currentUser;
  bool get _hasEmail => _user?.email != null && !(_user?.isAnonymous ?? true);

  final _repo = UserRepository.instance;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      // Фото
      if (_pickedImage != null) {
        setState(() => _uploadingPhoto = true);
        await _repo.uploadPhoto(_pickedImage!);
        if (mounted) {
          setState(() => _uploadingPhoto = false);
        }
      }

      // Имя
      final newName = _nameCtrl.text.trim();
      if (newName != (_user?.displayName ?? '').trim()) {
        await _repo.updateDisplayName(newName);
      }

      // Пароль — только если секция открыта и поля заполнены
      if (_changePassword && _currPassCtrl.text.isNotEmpty) {
        await _repo.updatePassword(
          currentPassword: _currPassCtrl.text,
          newPassword: _newPassCtrl.text,
        );
      }

      if (mounted) {
        _showSuccess('Профиль обновлён');
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showError(_mapError(e.code));
      }
    } catch (_) {
      if (mounted) {
        _showError('Ошибка сохранения. Попробуйте снова.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _uploadingPhoto = false;
        });
      }
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
        'wrong-password'        => 'Неверный текущий пароль',
        'invalid-credential'    => 'Неверный текущий пароль',
        'weak-password'         => 'Слишком простой пароль',
        'requires-recent-login' => 'Выйдите и войдите снова',
        _                       => 'Ошибка: $code',
      };

  @override
  Widget build(BuildContext context) {
    final photoUrl = _user?.photoURL;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Поля ─────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),

                      // Аватар
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 56,
                              backgroundColor: AppColors.primary,
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (photoUrl != null
                                      ? NetworkImage(photoUrl) as ImageProvider
                                      : null),
                              child: (_pickedImage == null && photoUrl == null)
                                  ? Text(
                                      ((_user?.displayName ?? '').trim().isEmpty
                                          ? '?'
                                          : _user!.displayName![0].toUpperCase()),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            if (_uploadingPhoto)
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black38,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _saving ? null : _pickPhoto,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Имя
                      const _Label(text: 'Имя'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: AppValidators.name,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15),
                        decoration: _fieldDecoration(
                            'Ваше имя', Icons.person_outline_rounded),
                      ),

                      // Смена пароля — только для email-пользователей
if (_hasEmail) ...[
  const SizedBox(height: 24),
  const _Label(text: 'Смена пароля'),
  const SizedBox(height: 8),
  _PassField(
    controller: _currPassCtrl,
    hint: 'Текущий пароль',
    obscure: _obscureCurr,
    onToggle: () => setState(() => _obscureCurr = !_obscureCurr),
    validator: (v) {
      if (_newPassCtrl.text.isEmpty) return null; // не обязательно если новый не заполнен
      if (v == null || v.isEmpty) return 'Введите текущий пароль';
      return null;
    },
  ),
  const SizedBox(height: 10),
  _PassField(
    controller: _newPassCtrl,
    hint: 'Новый пароль',
    obscure: _obscureNew,
    onToggle: () => setState(() => _obscureNew = !_obscureNew),
    validator: (v) {
      if (v == null || v.isEmpty) return null; // необязательное поле
      return AppValidators.password(v);
    },
  ),
  const SizedBox(height: 10),
  _PassField(
    controller: _confPassCtrl,
    hint: 'Повторите новый пароль',
    obscure: _obscureConf,
    onToggle: () => setState(() => _obscureConf = !_obscureConf),
    validator: (v) {
      if (_newPassCtrl.text.isEmpty) return null;
      return AppValidators.confirmPassword(v, _newPassCtrl.text);
    },
  ),
],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── Одна кнопка снизу ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}

// ─── Вспомогательные виджеты ─────────────────────────────────────

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textHint,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _PassField extends StatelessWidget {
  const _PassField({
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}