import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoo_app/models/todo_model.dart';

class DatabaseService extends ChangeNotifier {
  static late Isar isar;

  // Isaar baslat
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([TodoSchema], directory: dir.path);
  }

  // Gorev icin liste olustur
  List<Todo> currentTodos = [];

  //GOREV EKLE
  Future<void> addTodo(String text) async {
    final newTodo = Todo()..text = text; // .. operatoruyle degıstırebılrıız
    await isar.writeTxn(() => isar.todos.put(newTodo));
    await fetchTodos();
    //   notifyListeners();
  }

  // Görevleri Getir
  Future<void> fetchTodos() async {
    currentTodos = await isar.todos.where().findAll();
    notifyListeners();
  }

// Görev Güncelle
  Future<void> updateTodo(Todo todo) async {
    final existingTodo = await isar.todos.get(todo.id);
    if (existingTodo != null) {
      await isar.writeTxn(() => isar.todos.put(todo));
    }
    await fetchTodos();
  }

  // Görev Sil
  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() => isar.todos.delete(id));
    await fetchTodos();
  }
}
