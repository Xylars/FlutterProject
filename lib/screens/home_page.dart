import 'package:flutter/material.dart';
import 'package:flutterproject/data/database.dart';
import 'package:flutterproject/utils/dialog_box.dart';
import 'package:flutterproject/utils/todo_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoDatabase db = TodoDatabase();

  // text controller
  final _controller = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),);
  }

  void checkBoxChanged(bool? value, int index, bool completed) {
    setState(() {
      if (completed) {
        final task = db.todoListCompleted[index];
        task[1] = false;
        db.todoList.add(task);
        db.todoListCompleted.removeAt(index);
        showSnackBar("Restored task successfully!");
      }

      else {
        final task = db.todoList[index];
        task[1] = true;
        db.todoListCompleted.add(task);
        db.todoList.removeAt(index);
        showSnackBar("🎉 Great job! You completed a task!");
      }
      db.updateData();
    });
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: (dateTime) {
            setState(() {
              db.todoList.add([
                _controller.text,
                false,            
                dateTime,        
              ]);
              _controller.clear();
            });
            db.updateData();
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index, bool completed) {
    setState(() {
      if (completed) {
        db.todoListCompleted.removeAt(index);
      }
      else {
        db.todoList.removeAt(index);
      }
    });
    showSnackBar("Deleted task successfully!");
    db.updateData();
  }
  void editTask(int index) {
    final task = db.todoList[index];
    _controller.text = task[0];
    DateTime? taskDate = task[2];
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          initialDateTime: taskDate,
          onSave: (dateTime) {
            setState(() {
              task[0] = _controller.text;
              task[2] = dateTime;
            });
            db.updateData();
            _controller.clear();
            Navigator.of(context).pop();
            showSnackBar("Task updated successfully!");
          },
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );

  }

  Widget _buildHome() {
    if (db.todoList.isEmpty) {
      return const Center(child: Text("Add your first task!"));
    }
    return ListView.builder(
      itemCount: db.todoList.length,
      itemBuilder: (context, index) {
        final task = db.todoList[index];
        final time = task.length > 2 ? task[2] : null;

        return TodoTitle(
          taskName: task[0],
          taskCompleted: task[1],
          time: time,
          onChanged: (value) => checkBoxChanged(value, index, false),
          deleteFunction: (context) => deleteTask(index, false),
          onEdit: (context) => editTask(index),
        );
      },
    );
  }

  Widget _buildCompleted() {

    if (db.todoListCompleted.isEmpty) {
      return const Center(child: Text("No completed tasks yet."));
    }

    return ListView.builder(
      itemCount: db.todoListCompleted.length,
      itemBuilder: (context, index) {
        final task = db.todoListCompleted[index];
        final time = task.length > 2 ? task[2] : null;

        return TodoTitle(
          taskName: task[0],
          taskCompleted: task[1],
          time: time,
          onChanged: (value) => checkBoxChanged(value, index, true),
          deleteFunction: (context) => deleteTask(index, true),
          onEdit: null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      _buildCompleted(),
    ];

    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text("📋 My ToDo List"),
        elevation: 0,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      )
          : null, // only show add button in home page
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Completed',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
    );
  }
}
