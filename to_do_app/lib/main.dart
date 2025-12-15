import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: '/',
      routes: {'/': (context) => const MyHomePage(title: 'To-Do')},
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseController dbcontroller = DatabaseController();
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await dbcontroller.getTodos();
    setState(() {
      todos = List<Map<String, dynamic>>.from(data);
      todos.sort((a, b) => b['priority'].compareTo(a['priority']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () => _addTask(context), icon: Icon(Icons.add)),
        ],
      ),
      body: ListView(
        children: [
          for (int i = 0; i < todos.length; i++)
            Card(
              child: ListTile(
                title: Text(todos[i]['task']),
                trailing: Checkbox(
                  value: todos[i]['state'] == 1,
                  onChanged: (value) async {
                    dbcontroller.deleteTodo(todos[i]['id']);
                    setState(() {
                      _loadTasks();
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _addTask(BuildContext context) {
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
                      Navigator.popAndPushNamed(context, '/');
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

Future<void> _editTask(BuildContext context) {
  final inputTask = TextEditingController();
  final db = DatabaseController();
  int priority = 0;
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
                        db.insertTodo(inputTask.text, priority);
                      }
                      Navigator.popAndPushNamed(context, '/');
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
