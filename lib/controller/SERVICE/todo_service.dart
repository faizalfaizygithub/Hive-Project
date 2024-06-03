import 'package:hive_demo/model/todo_model.dart';
import 'package:hive_flutter/adapters.dart';

class TodoService {
  Box<Todo>? _todoBox;

  Future<void> openBox() async {
    _todoBox = await Hive.openBox<Todo>('todos');
  }

  Future<void> closeBox() async {
    await _todoBox!.close();
  }

  //add todo

  Future<void> AddTodo(Todo todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.add(todo);
  }

// get all todos
  Future<List<Todo>> getTodos() async {
    if (_todoBox == null) {
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  //update todo

  Future<void> updateTodo(int index, Todo todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.putAt(index, todo);
  }

//delte todo
  Future<void> deleteTodo(int index) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.deleteAt(index);
  }
}
