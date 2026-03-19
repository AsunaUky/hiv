import 'package:flutter/material.dart';

// TODO: реализовать статью
class InfoScreen extends StatelessWidget {
  const InfoScreen({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Информация'));
  }
}