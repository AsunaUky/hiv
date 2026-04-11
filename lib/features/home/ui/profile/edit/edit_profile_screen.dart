import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiv/core/services/permission_service.dart';
import 'package:hiv/features/home/ui/profile/edit/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/core/utils/validator.dart';

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
  bool _saving = false;
  bool _uploadingPhoto = false;

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

  // FIX [P2-02]: запрашиваем пермишн на галерею перед picker
  Future<void> _pickPhoto() async {
    final granted = await PermissionService.requestGallery();
    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Нет доступа к галерее. Разрешите в настройках.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
      return;
    }
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512, maxHeight: 512, imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (_pickedImage != null) {
        setState(() => _uploadingPhoto = true);
        await _repo.uploadPhoto(_pickedImage!);
        await FirebaseAuth.instance.currentUser?.reload();
        if (mounted) setState(() => _uploadingPhoto = false);
      }
      final newName = _nameCtrl.text.trim();
      if (newName != (_user?.displayName ?? '').trim()) {
        await _repo.updateDisplayName(newName);
      }
      if (_newPassCtrl.text.isNotEmpty) {
        await _repo.updatePassword(
          currentPassword: _currPassCtrl.text,
          newPassword: _newPassCtrl.text,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(tr('edit.success')),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_mapError(e.code)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(tr('edit.errorSave')),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() { _saving = false; _uploadingPhoto = false; });
    }
  }

  String _mapError(String code) => switch (code) {
    'wrong-password'        => tr('edit.wrongPassword'),
    'invalid-credential'    => tr('edit.wrongPassword'),
    'weak-password'         => tr('edit.weakPassword'),
    'requires-recent-login' => tr('edit.recentLogin'),
    _                       => '${tr("common.error")}: $code',
  };

  @override
  Widget build(BuildContext context) {
    final photoUrl = _user?.photoURL;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(tr('edit.title')),
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Stack(children: [
                          CircleAvatar(
                            radius: 56,
                            backgroundColor: AppColors.primary,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : (photoUrl != null ? NetworkImage(photoUrl) as ImageProvider : null),
                            child: (_pickedImage == null && photoUrl == null)
                                ? Text(
                                    ((_user?.displayName ?? '').trim().isEmpty ? '?' : _user!.displayName![0].toUpperCase()),
                                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white),
                                  )
                                : null,
                          ),
                          if (_uploadingPhoto)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                                child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                              ),
                            ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: GestureDetector(
                              onTap: _saving ? null : _pickPhoto,
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary, shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 28),
                      _Label(text: tr('edit.nameLabel')),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: AppValidators.name,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                        decoration: _dec(tr('edit.namePlaceholder'), Icons.person_outline_rounded),
                      ),
                      if (_hasEmail) ...[
                        const SizedBox(height: 24),
                        _Label(text: tr('edit.changePasswordLabel')),
                        const SizedBox(height: 8),
                        _PassField(
                          controller: _currPassCtrl, hint: tr('edit.currentPassword'),
                          obscure: _obscureCurr, onToggle: () => setState(() => _obscureCurr = !_obscureCurr),
                          validator: (v) { if (_newPassCtrl.text.isEmpty) return null; if (v == null || v.isEmpty) return tr('edit.currentPassword'); return null; },
                        ),
                        const SizedBox(height: 10),
                        _PassField(
                          controller: _newPassCtrl, hint: tr('edit.newPassword'),
                          obscure: _obscureNew, onToggle: () => setState(() => _obscureNew = !_obscureNew),
                          validator: (v) { if (v == null || v.isEmpty) return null; return AppValidators.password(v); },
                        ),
                        const SizedBox(height: 10),
                        _PassField(
                          controller: _confPassCtrl, hint: tr('edit.confirmPassword'),
                          obscure: _obscureConf, onToggle: () => setState(() => _obscureConf = !_obscureConf),
                          validator: (v) { if (_newPassCtrl.text.isEmpty) return null; return AppValidators.confirmPassword(v, _newPassCtrl.text); },
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(tr('common.save')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
    hintText: hint, hintStyle: const TextStyle(color: AppColors.textHint),
    prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
    filled: true, fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
  );
}

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2));
}

class _PassField extends StatelessWidget {
  const _PassField({required this.controller, required this.hint, required this.obscure, required this.onToggle, this.validator});
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller, obscureText: obscure, validator: validator,
    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
    decoration: InputDecoration(
      hintText: hint, hintStyle: const TextStyle(color: AppColors.textHint),
      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textHint, size: 20),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textHint, size: 20),
        onPressed: onToggle,
      ),
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
    ),
  );
}