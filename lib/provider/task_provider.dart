import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/database/task_database.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final TaskDatabaseHelper databaseHelper = new TaskDatabaseHelper();
  List<TaskCategory> categories = [
    TaskCategory(id: 1, title: 'Work'),
    TaskCategory(id: 2, title: 'Event'),
    TaskCategory(id: 3, title: 'Personal'),
    TaskCategory(id: 4, title: 'Shopping'),
  ];

  List<Task> taskList = [];

  fetchTask() {
    Future<List<Task>> tasks = databaseHelper.getTasks();
    tasks.then((task) {
      taskList = task;
      notifyListeners();
    });
  }

  getTasksLength(bool value) {
    return value ? showCompletedTask.length : taskList.length;
  }

  String appBarTitle(bool selectValue) {
    if (selectValue) {
      return 'Completed Tasks';
    } else {
      return 'All Tasks';
    }
  }

  List<Task> get showCompletedTask {
    return taskList.where((task) => task.complete == 1).toList();
  }

  void restoreTaskByUndo(Task task) {
    addTask(task);
    fetchTask();
    notifyListeners();
  }

  void addTask(Task task) {
    databaseHelper.saveTask(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    databaseHelper.updateTask(task);
  }

  void deleteTask(int id) {
    databaseHelper.deleteTask(id);
    fetchTask();
  }

  void completedTask(Task task) {
    task.complete = task.complete == 1 ? 0 : 1;
    updateTask(task);
    notifyListeners();
  }
}
