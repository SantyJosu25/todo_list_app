import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';
import '../utils/task_storage.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Cargar tareas desde el almacenamiento
  Future<void> _loadTasks() async {
    final tasks = await TaskStorage.loadTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  // Guardar tareas en el almacenamiento
  Future<void> _saveTasks() async {
    await TaskStorage.saveTasks(_tasks);
  }

  // Añadir una nueva tarea
  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
    _saveTasks();
  }

  // Eliminar una tarea
  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    _saveTasks();
  }

  // Marcar una tarea como completada
  void _toggleTaskCompletion(String id) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      }
    });
    _saveTasks();
  }

  // Editar una tarea
  void _editTask(Task updatedTask) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = updatedTask;
      }
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: _tasks.isEmpty
          ? Center(
        child: Text('No hay tareas. ¡Añade una!'),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: _tasks[index],
            onDelete: _deleteTask,
            onToggle: _toggleTaskCompletion,
            onEdit: (task) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                    onAddTask: _editTask,
                    initialTask: task,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onAddTask: _addTask),
            ),
          );
        },
      ),
    );
  }
}