import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseController.dart';
import 'pop_up.dart';

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
          IconButton(
            onPressed: () async {
              await addTask(context);
              _loadTasks();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (int i = 0; i < todos.length; i++)
            Card(
              child: ListTile(
                title: Text(todos[i]['task']),
                onTap: () async {
                  await editTask(
                    context,
                    todos[i]['id'],
                    todos[i]['task'],
                    todos[i]['priority'],
                  );
                  _loadTasks();
                },
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
