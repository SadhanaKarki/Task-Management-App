import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class TaskRepository {
  static const String _fileName = 'tasks.json';
   
  // gets the application's documents directory path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  // gets a reference to the JSON file where tasks are stored
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }
  
  // loads tasks from the JSON file
  Future<List<Task>> loadTasks() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // saves tasks to the JSON file
  Future<void> saveTasks(List<Task> tasks) async {
    final file = await _localFile;
    final jsonList = tasks.map((task) => task.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  // adds a new task to the JSON file
  Future<void> addTask(Task task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  // updates an existing task in the JSON file
  Future<void> updateTask(Task task) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  // deletes a task from the JSON file
  Future<void> deleteTask(String taskId) async {
    final tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }
}
