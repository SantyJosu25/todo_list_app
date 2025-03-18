import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks';

  // Guardar tareas en el dispositivo
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode({
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
    })).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Cargar tareas desde el dispositivo
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((taskJson) {
      final taskMap = jsonDecode(taskJson);
      return Task(
        id: taskMap['id'],
        title: taskMap['title'],
        description: taskMap['description'],
        isCompleted: taskMap['isCompleted'],
      );
    }).toList();
  }
}