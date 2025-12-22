import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/alarm.dart';
import 'package:to_do_app/pomodoro.dart';
import 'databaseController.dart';
import 'pop_up.dart';
import 'pomodoro.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'To-Do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 81, 255),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'To-Do'),
        '/pomodoro': (context) => Pomodoro(),
      },
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
  Set<int> pendingDeletion = {};

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
        backgroundColor: Colors.blue[600],
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              await addTask(context);
              _loadTasks();
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/pomodoro'),
            icon: Icon(Icons.hourglass_top),
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
                  value:
                      todos[i]['state'] == 1 ||
                      pendingDeletion.contains(todos[i]['id']),
                  onChanged: (value) async {
                    final id = todos[i]['id'];

                    setState(() {
                      pendingDeletion.add(id);
                    });

                    await Future.delayed(const Duration(milliseconds: 400));

                    await dbcontroller.deleteTodo(id);

                    pendingDeletion.remove(id);

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
