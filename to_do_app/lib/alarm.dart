import 'dart:io';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

final now = DateTime.now().add(const Duration(seconds: 2));

final alarmSettings = AlarmSettings(
  id: 1,
  dateTime: now,
  assetAudioPath: 'assets/alarm.mp3',
  loopAudio: true,
  vibrate: true,
  warningNotificationOnKill: Platform.isAndroid,
  androidFullScreenIntent: true,
  volumeSettings: VolumeSettings.fade(
    volume: 0.8,
    fadeDuration: Duration(seconds: 5),
    volumeEnforced: true,
  ),
  notificationSettings: const NotificationSettings(
    title: 'This is the title',
    body: 'This is the body',
    stopButton: 'Stop the alarm',
    icon: 'notification_icon',
    iconColor: Colors.blue,
  ),
);
