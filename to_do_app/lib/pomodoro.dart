import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/alarm.dart';
import 'dart:async';
import 'alarm.dart';

class Pomodoro extends StatefulWidget {
  @override
  State<Pomodoro> createState() => PomodoroState();
}

class PomodoroState extends State<Pomodoro> {
  @override
  void initState() {
    super.initState();
  }

  Timer? _timer;
  int work = 25 * 60;
  int rest = 5 * 60;
  int timeToDisplay = 0;
  int currentTime = 0;
  bool running = false;
  bool paused = false;
  bool stop = false;
  _runTimer() {
    running = true;

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) async {
      if (currentTime == 0) {
        timer.cancel();
        paused = false;
        running = false;
        stop = true;
        setState(() {});
      } else {
        setState(() {
          currentTime--;
        });
      }
    });
  }

  startTimer(bool isWork) {
    setState(() {
      running = true;
      paused = false;
      currentTime = isWork ? work : rest;
    });
    startAlarm(Duration(seconds: currentTime));

    _runTimer();
  }

  pauseTimer() async {
    _timer?.cancel();

    await Alarm.stop(1);
    setState(() {
      paused = true;
    });
  }

  resumeTimer() {
    if (running) return;
    setState(() {
      paused = false;
    });
    startAlarm(Duration(seconds: currentTime));
    _runTimer();
  }

  stopTimer() async {
    _timer?.cancel();
    await Alarm.stop(1);
    setState(() {
      running = false;
      paused = false;
      currentTime = work;
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text('Pomodoro'),
        actions: [
          IconButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.popAndPushNamed(context, '/');
            },
            icon: Icon(Icons.checklist_sharp),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(flex: 1),
            Text(
              formatTime(currentTime),
              style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold),
            ),
            Visibility(
              visible: stop,
              child: FloatingActionButton(
                child: Text('STOP'),
                onPressed: () async {
                  await Alarm.stop(1);
                  stop = false;
                  setState(() {});
                },
                backgroundColor: Colors.red,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !running && !stop,
                  child: FloatingActionButton(
                    heroTag: 'startTimer25min',
                    onPressed: () => startTimer(true),
                    child: Text('Arbejde'),
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 20, height: 30),
                Visibility(
                  visible: !running && !stop,
                  child: FloatingActionButton(
                    heroTag: 'startTimer5min',
                    onPressed: () => startTimer(false),
                    child: Text('Pause'),
                    backgroundColor: Colors.blue,
                  ),
                ),

                Visibility(
                  visible: (running && !paused),
                  child: FloatingActionButton(
                    heroTag: 'pauseTimer',
                    onPressed: pauseTimer,
                    child: Icon(Icons.pause),
                    backgroundColor: Colors.blue,
                  ),
                ),
                Visibility(
                  visible: paused,
                  child: FloatingActionButton(
                    heroTag: 'resumeTimer',
                    onPressed: resumeTimer,
                    child: Icon(Icons.play_arrow),
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 20, height: 30),
                Visibility(
                  visible: paused,
                  child: FloatingActionButton(
                    heroTag: 'stopTimer',
                    onPressed: stopTimer,
                    child: Icon(Icons.stop),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
