import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/prefs_service.dart';
import 'ui/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Abrimos caja Hive para preferencias y estado ligero
  await Hive.openBox('prefs'); // tema, idioma, últimos filtros, etc.

  // Init service de preferencias
  Get.put(PrefsService());

  runApp(const HabitsApp());
}

class HabitsApp extends StatelessWidget {
  const HabitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<PrefsService>();
    return ValueListenableBuilder(
      valueListenable: prefs.box.listenable(),
      builder: (_, __, ___) {
        final isDark = prefs.isDarkMode;
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Habits & Streaks',
          theme: ThemeData(
            colorSchemeSeed: Colors.teal,
            brightness: isDark ? Brightness.dark : Brightness.light,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
