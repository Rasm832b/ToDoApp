import 'dart:io';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';




Future<void> startAlarm(Duration duration) async {
  final alarmSettings = AlarmSettings(
    id: 1,
    dateTime: DateTime.now().add(duration),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 5), volume: 0.8, volumeEnforced: true),
    androidFullScreenIntent: true,
    warningNotificationOnKill: Platform.isAndroid,
    notificationSettings: const NotificationSettings(
    title: 'This is the title',
    body: 'This is the body',
    stopButton: 'Stop the alarm',
    icon: 'notification_icon',
    iconColor: Colors.blue,
  ),
  );

  await Alarm.set(alarmSettings: alarmSettings);
}
