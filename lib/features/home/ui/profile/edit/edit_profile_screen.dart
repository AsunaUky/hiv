import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiv/core/services/permission_service.dart';
import 'package:hiv/domain/repositories/user_repository.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/core/utils/validator.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

extension _ContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = UserRepository.instance;

  late final TextEditingController _nameCtrl;
  final _currPassCtrl = TextEditingController();
  final _newPassCtrl  = TextEditingController();
  final _confPassCtrl = TextEditingController();

  bool _obscureCurr = true;
  bool _obscureNew  = true;
  bool _obscureConf = true;

  File?   _pickedImage;
  String? _firestorePhotoUrl;
  bool    _saving  = false;
  bool    _picking = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  // Форма смены пароля только для email/password пользователей.
  bool get _hasEmailPassword =>
      _user?.providerData.any(
        (p) => p.providerId == EmailAuthProvider.PROVIDER_ID,
      ) ??
      false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '');
    _loadPhoto();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPhoto() async {
    final url = await _repo.getPhotoUrl();
    if (mounted) setState(() => _firestorePhotoUrl = url);
  }

  Future<void> _pickPhoto() async {
    if (_picking) return;
    _picking = true;
    try {
      // На Android 13+ Permission.photos → READ_MEDIA_IMAGES (системный пикер).
      // На Android ≤12 и iOS — стандартный запрос разрешения.
      PermissionStatus status = await PermissionService.galleryStatus();

      if (!status.isGranted && !status.isLimited) {
        status = await PermissionService.requestGalleryPermission();
        if (!mounted) return;
        // isPermanentlyDenied — пользователь запретил навсегда
        if (status.isPermanentlyDenied) {
          _showSnackBar(context.l10n.editNoGalleryAccess, isError: true);
          await PermissionService.openSettings();
          return;
        }
        // isDenied — просто отказал, не открываем галерею
        if (!status.isGranted && !status.isLimited) {
          _showSnackBar(context.l10n.editNoGalleryAccess, isError: true);
          return;
        }
      }

      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() => _pickedImage = File(picked.path));
    } finally {
      _picking = false;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      if (_pickedImage != null) {
        final url = await _repo.uploadPhoto(_pickedImage!);
        if (mounted) setState(() => _firestorePhotoUrl = url);
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
        _showSnackBar(context.l10n.editSuccess);
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _showSnackBar(_mapError(e.code), isError: true);
    } catch (_) {
      if (mounted) _showSnackBar(context.l10n.editErrorSave, isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.error : AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  String _mapError(String code) {
    final l10n = context.l10n;
    return switch (code) {
      'wrong-password' || 'invalid-credential' => l10n.editWrongPassword,
      'weak-password'         => l10n.editWeakPassword,
      'requires-recent-login' => l10n.editRecentLogin,
      _ => '${l10n.commonError}: $code',
    };
  }

  ImageProvider? get _avatarImage {
    if (_pickedImage != null) return FileImage(_pickedImage!);
    if (_firestorePhotoUrl != null) {
      if (_firestorePhotoUrl!.startsWith('data:')) {
        final base64Str = _firestorePhotoUrl!.split(',').last;
        return MemoryImage(base64Decode(base64Str));
      }
      return NetworkImage(_firestorePhotoUrl!);
    }
    return null;
  }

  String get _avatarInitial {
    final name = (_user?.displayName ?? '').trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editTitle)),
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
                      _AvatarPicker(
                        image: _avatarImage,
                        initial: _avatarInitial,
                        onTap: _saving ? null : _pickPhoto,
                      ),
                      const SizedBox(height: 28),
                      _SectionLabel(l10n.editNameLabel),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => AppValidators.name(v, l10n),
                        decoration: InputDecoration(
                          hintText: l10n.editNamePlaceholder,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                      ),
                      if (_hasEmailPassword) ...[
                        const SizedBox(height: 24),
                        _SectionLabel(l10n.editChangePasswordLabel),
                        const SizedBox(height: 8),
                        _PassField(
                          controller: _currPassCtrl,
                          hint: l10n.editCurrentPassword,
                          obscure: _obscureCurr,
                          onToggle: () =>
                              setState(() => _obscureCurr = !_obscureCurr),
                          validator: (v) {
                            if (_newPassCtrl.text.isEmpty) return null;
                            if (v == null || v.isEmpty) {
                              return l10n.editCurrentPassword;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _PassField(
                          controller: _newPassCtrl,
                          hint: l10n.editNewPassword,
                          obscure: _obscureNew,
                          onToggle: () =>
                              setState(() => _obscureNew = !_obscureNew),
                          validator: (v) => v == null || v.isEmpty
                              ? null
                              : AppValidators.password(v, context.l10n),
                        ),
                        const SizedBox(height: 10),
                        _PassField(
                          controller: _confPassCtrl,
                          hint: l10n.editConfirmPassword,
                          obscure: _obscureConf,
                          onToggle: () =>
                              setState(() => _obscureConf = !_obscureConf),
                          validator: (v) => _newPassCtrl.text.isEmpty
                              ? null
                              : AppValidators.confirmPassword(
                                  v, _newPassCtrl.text, context.l10n),
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
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(l10n.commonSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.image,
    required this.initial,
    required this.onTap,
  });

  final ImageProvider? image;
  final String         initial;
  final VoidCallback?  onTap;

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.primary,
              backgroundImage: image,
              child: image == null
                  ? Text(initial,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white))
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.photo_library_outlined,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textHint,
            letterSpacing: 1.2),
      );
}

class _PassField extends StatelessWidget {
  const _PassField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  final TextEditingController      controller;
  final String                     hint;
  final bool                       obscure;
  final VoidCallback               onToggle;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            onPressed: onToggle,
          ),
        ),
      );
}