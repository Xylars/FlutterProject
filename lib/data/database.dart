import 'package:hive/hive.dart';

class TodoDatabase {
  List todoList = [];
  List todoListCompleted = [];

  final _myBox = Hive.box('box');

  void loadData() {
    todoList = _myBox.get("TODOLIST", defaultValue: []);
    todoListCompleted = _myBox.get("TODOLIST_COMPLETED", defaultValue: []);
  }

  void updateData() {
    _myBox.put("TODOLIST", todoList);
    _myBox.put("TODOLIST_COMPLETED", todoListCompleted);

  }
}

