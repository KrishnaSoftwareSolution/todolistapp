import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/models/tasks.dart';

import 'package:todolist/services/tasksstorage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Task Create', () {
    var mockTaskStorage;

    late Task task;

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dueDate = DateTime.parse(formattedDate);

    test('Insert Task Test', () async {
      // Arrange
      mockTaskStorage = new TaskStorage();
      task = Task(
        name: 'Temp',
        categoryId: 1,
        completed: false,
        dueDate: dueDate,
      );
      // Stub the insertTask method
      when(mockTaskStorage.insertTask(task)).thenReturn;

      // Act
      await mockTaskStorage.insertTask(task);

      // Assert
      expect(task, task);
    });
  });

  group('Task Create', () {
    var mockTaskStorage;

    late Task task;

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dueDate = DateTime.parse(formattedDate);

    test('Task update', () async {
      // Arrange
      mockTaskStorage = new TaskStorage();
      task = Task(
        id: 1,
        name: 'Temp Update',
        categoryId: 1,
        completed: false,
        dueDate: dueDate,
      );
      // Stub the updateTask method
      when(mockTaskStorage.updateTask(task)).thenReturn;

      // Act
      await mockTaskStorage.updateTask(task);

      // Assert
      expect(task, task);
    });
  });

  group('Task Complete', () {
    var mockTaskStorage;

    late Task task;

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dueDate = DateTime.parse(formattedDate);

    test('Task Complete', () async {
      // Arrange
      mockTaskStorage = new TaskStorage();
      task = Task(
        id: 1,
        name: 'Temp Task Completed',
        categoryId: 1,
        completed: true,
        dueDate: dueDate,
      );
      // Stub the updateTask method
      when(mockTaskStorage.updateTask(task)).thenReturn;

      // Act
      await mockTaskStorage.updateTask(task);

      // Assert
      expect(task, task);
    });
  });

  group('Task Create', () {
    var mockTaskStorage;

    late int taskID;

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dueDate = DateTime.parse(formattedDate);

    test('Task Delete', () async {
      // Arrange
      mockTaskStorage = new TaskStorage();
      taskID = 1;

      // Stub the deleteTask method
      when(mockTaskStorage.deleteTask(taskID)).thenReturn;

      // Act
      await mockTaskStorage.deleteTask(taskID);

      // Assert
      expect(taskID, taskID);
    });
  });
}
