// lib/task_storage.dart
import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/models/category.dart';
import 'package:todolist/models/tasks.dart';

class TaskStorage {
  static final TaskStorage _instance = TaskStorage._internal();
  factory TaskStorage() => _instance;
  TaskStorage._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            category_id INTEGER,
            completed INTEGER,
            due_date DATETIME,
            FOREIGN KEY (category_id) REFERENCES categories (id)
          )
        ''');

        // Insert default categories
        await db.insert('categories', {'name': 'Work'});
        await db.insert('categories', {'name': 'Personal'});
        await db.insert('categories', {'name': 'Shopping'});
      },
    );
  }

  // Category CRUD operations
  Future<void> insertCategory(CategoryTask category) async {
    final db = await database;
    await db.insert('categories', category.toJson());
  }

  Future<void> updateCategory(CategoryTask category) async {
    final db = await database;
    await db.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int? categoryID) async {
    final db = await database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryID],
    );
  }

  Future<String> fetchCategoryNameByID(int? id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CategoryTask.fromJson(maps.first).name;
    } else {
      return '';
    }
  }

  Future<List<CategoryTask>> fetchCategories() async {
    final db = await database;
    final maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return CategoryTask.fromJson(maps[i]);
    });
  }

  Future<void> insertTask(Task? task) async {
    if (task != null) {
      final db = await database;
      await db.insert('tasks', task.toJson());
    }
  }

  Future<List<Task>> fetchTasks() async {
    final db = await database;
    final maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
