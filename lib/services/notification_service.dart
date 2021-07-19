import 'package:fairplay/services/shared_pref_services.dart';
import 'package:fairplay/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static int id = 0;
  static BuildContext context;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');

  initNotifications() async {
    _requestPermissions();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              print('received');
            });
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  setContext(ctx) {
    context = ctx;
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: false,
          sound: true,
        );
  }

  Future<void> showNotification(String title, String body) async {
    flutterLocalNotificationsPlugin.cancelAll();
    if (await SharedPrefService().getData(StaticData.NOTIFICATION) ?? true) {
      print('notification fire');

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'your channel name',
              'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin
          .show(id, title, body, platformChannelSpecifics, payload: 'item x');
      id++;
    }
  }

  Future<void> showFullScreenNotification() async {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('The Match Has Finish'),
        content: const Text(
            'To Restart the Game Click Restart Or Click Cancel For Going to Home Screen'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              //todo reset the team
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
