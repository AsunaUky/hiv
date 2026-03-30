import 'package:flutter/material.dart';

// TODO: реализовать профиль гостя
// Должен содержать: сообщение о том что пользователь не авторизован,
// кнопки "Войти" и "Зарегистрироваться"
class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Гость'));
  }
}