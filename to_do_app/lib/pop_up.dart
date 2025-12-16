import 'dart:async';
import 'package:flutter/material.dart';
import 'databaseController.dart';

// add task popup dialog window.
Future<void> addTask(BuildContext context) async {
  final inputTask = TextEditingController();
  final db = DatabaseController();
  int priority = 0;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add task'),
            actions: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter task',
                ),
                controller: inputTask,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    child: Text('Low'),
                    backgroundColor: priority == 0
                        ? Colors.blue[400]
                        : Colors.grey[100],
                    onPressed: () {
                      setState(() {
                        priority = 0;
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Text('Medium'),
                    backgroundColor: priority == 1
                        ? Colors.blue[400]
                        : Colors.grey[100],
                    onPressed: () {
                      setState(() {
                        priority = 1;
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Text('High'),
                    backgroundColor: priority == 2
                        ? Colors.blue[400]
                        : Colors.grey[100],
                    onPressed: () {
                      setState(() {
                        priority = 2;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Add'),
                    onPressed: () {
                      if (inputTask.text.isNotEmpty) {
                        db.insertTodo(inputTask.text, priority);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

// Edit task popup dialog box
Future<void> editTask(BuildContext context, int id, String test, int prio) {
  final inputTask = TextEditingController();
  inputTask.text = test;
  final db = DatabaseController();
  int priority = prio;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit task'),
            actions: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter task',
                ),
                controller: inputTask,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    child: Text('Low'),
                    backgroundColor: priority == 0
                        ? Colors.blue[400]
                        : Colors.grey[100],
                    onPressed: () {
                      setState(() {
                        priority = 0;
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Text('Medium'),
                    backgroundColor: priority == 1
                        ? Colors.blue[400]
                        : Colors.grey[100],
                    onPressed: () {
                      setState(() {
                        priority = 1;
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Text('High'),
                    backgroundColor: priority == 2
                        ? Colors.blue[400]
                        : Colors.grey[100],
                    onPressed: () {
                      setState(() {
                        priority = 2;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Done'),
                    onPressed: () {
                      if (inputTask.text.isNotEmpty) {
                        db.updateTodo(id, inputTask.text, priority);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
