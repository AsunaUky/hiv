import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hiv/features/app/ui/app.dart';
import 'package:hiv/firebase_options.dart';

void main() async {
  // Обязательно вызываем перед любыми async-операциями.
  WidgetsFlutterBinding.ensureInitialized();

  // Загружаем .env (если файла нет — не падаем, просто логируем).
  try {
    await dotenv.load();
    // AppLogger.info('main: .env загружен');
  } catch (_) {
    // AppLogger.warning('main: .env файл не найден — используем значения по умолчанию');
  }

  // Инициализируем Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // AppLogger.info('main: Firebase инициализирован');

  // Запускаем приложение.
  runApp(const HivApp());
}
