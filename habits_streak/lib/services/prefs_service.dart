import 'package:get/get.dart';
import 'package:hive/hive.dart';

class PrefsService extends GetxService {
  late final Box box;

  PrefsService() : box = Hive.box('prefs');

  bool get isDarkMode => box.get('darkMode', defaultValue: false) as bool;
  set isDarkMode(bool v) => box.put('darkMode', v);

  // Config rápida para la app
  int get defaultReminderHour => box.get('reminderHour', defaultValue: 20) as int;
  set defaultReminderHour(int v) => box.put('reminderHour', v);
}
