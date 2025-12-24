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

    Alarm.ringStream.stream.listen((_) {
      setState(() {
        alarmRinging = true;
        stop = true;
        running = false;
        paused = false;
        currentTime = 0;
        endTime = null;
      });
    });
  }

  DateTime? endTime;
  Timer? _timer;
  int work = 25 * 60;
  int rest = 5 * 60;
  int timeToDisplay = 0;
  int currentTime = 0;
  bool running = false;
  bool paused = false;
  bool stop = false;
  bool alarmRinging = false;
  bool get isIdle => !running && !paused && !alarmRinging;
  bool get isRunning => running;
  bool get isPaused => paused;
  bool get isRinging => alarmRinging;

  _runTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (endTime == null) return;

      final remaining = endTime!.difference(DateTime.now()).inSeconds;

      if (remaining <= 0) {
        _timer?.cancel();
        setState(() {
          running = false;
          paused = false;
          stop = true;
        });
      } else {
        setState(() {
          currentTime = remaining;
        });
      }
    });
  }

  startTimer(bool isWork) {
    final duration = Duration(seconds: isWork ? work : rest);
    setState(() {
      running = true;
      paused = false;
      stop = false;
      currentTime = duration.inSeconds;
      endTime = DateTime.now().add(duration);
    });
    startAlarm(duration);

    _runTimer();
  }

  pauseTimer() async {
    _timer?.cancel();
    await Alarm.stop(1);

    final remaining = endTime!.difference(DateTime.now()).inSeconds;

    setState(() {
      paused = true;
      running = false;
      currentTime = remaining;
      endTime = null;
    });
  }

  resumeTimer() {
    if (!paused) return;

    setState(() {
      paused = false;
      running = true;
      endTime = DateTime.now().add(Duration(seconds: currentTime));
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
              visible: isRinging,
              child: FloatingActionButton(
                child: Text('STOP'),
                onPressed: () async {
                  await Alarm.stop(1);
                  setState(() {
                    stop = false;
                    alarmRinging = false;
                    currentTime = 0;
                  });
                },
                backgroundColor: Colors.red,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: isIdle,
                  child: FloatingActionButton(
                    heroTag: 'startTimer25min',
                    onPressed: () => startTimer(true),
                    child: Text('Arbejde'),
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 20, height: 30),
                Visibility(
                  visible: isIdle,
                  child: FloatingActionButton(
                    heroTag: 'startTimer5min',
                    onPressed: () => startTimer(false),
                    child: Text('Pause'),
                    backgroundColor: Colors.blue,
                  ),
                ),

                Visibility(
                  visible: isRunning,
                  child: FloatingActionButton(
                    heroTag: 'pauseTimer',
                    onPressed: pauseTimer,
                    child: Icon(Icons.pause),
                    backgroundColor: Colors.blue,
                  ),
                ),
                Visibility(
                  visible: isPaused,
                  child: FloatingActionButton(
                    heroTag: 'resumeTimer',
                    onPressed: resumeTimer,
                    child: Icon(Icons.play_arrow),
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 20, height: 30),
                Visibility(
                  visible: isPaused,
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
