import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/prefs_service.dart';
import '../controllers/habits_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HabitsController());
    final prefs = Get.find<PrefsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hábitos & Rachas'),
        actions: [
          IconButton(
            tooltip: 'Tema',
            onPressed: () => prefs.isDarkMode = !prefs.isDarkMode,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: Obx(() {
        if (c.habits.isEmpty) {
          return const Center(child: Text('Agrega tu primer hábito con +'));
        }
        return ListView.builder(
          itemCount: c.habits.length,
          itemBuilder: (_, i) {
            final h = c.habits[i];
            final streak = c.streakByHabit[h.id] ?? 0;
            return ListTile(
              title: Text(h.title),
              subtitle: Text('Racha: $streak día(s)'),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => c.logToday(h.id, value: 1),
                tooltip: 'Marcar HOY',
              ),
              onLongPress: () => c.removeHabit(h.id),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await showDialog<String>(
            context: context,
            builder: (ctx) {
              final ctrl = TextEditingController();
              return AlertDialog(
                title: const Text('Nuevo hábito'),
                content: TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(hintText: 'p. ej., Beber agua'),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                  FilledButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Crear')),
                ],
              );
            },
          );
          if (title != null && title.isNotEmpty) {
            await Get.find<HabitsController>().addHabit(title);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
