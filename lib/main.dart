import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hiv/features/app/ui/app.dart';
import 'package:hiv/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  try {
    await dotenv.load();
  } catch (_) {
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('kk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const HivApp(),
    ),
  );
}