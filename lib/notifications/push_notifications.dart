// sha-1: 49:37:2B:DD:98:22:C8:3E:52:FF:0A:94:3F:8E:50:BA:E6:F6:73:B7

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../bloc/dates_state_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotifications {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future initializeApp() async {
    //push notifications
    token = await FirebaseMessaging.instance.getToken(
        vapidKey:  'BLnSHIsIWPlptI0D3Bd1gcGBgX6E0aAdO-6b7CMDd8NsVBLhTcXMu61z7EeTXC8jYnthWsUR3kTS66QpsBf0Fxc'
    );
    print('FCM se ha inicializado correctamente');
    try {
      await http.post(Uri.parse('http:$ipPort/token'),
          body: {'token': token});
    } catch (e) {
      print('error');
    }
  }
/*

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);


   static Future _onBackgroundMessage(RemoteMessage message) async {
    if (message.data['type'] == 'new_cite') {
      _showNotification(
          message.data['title'],
          message.data['name'],
          message.data['appointmentId']
      );
    }
  }

  static Future _onMessage(RemoteMessage message) async {
    if (message.data['type'] == 'new_cite') {
      _showNotification(
          message.data['title'],
          message.data['name'],
          message.data['appointmentId']
      );
    }
  }

  static Future _onMessageOpenedApp(RemoteMessage message) async {
    if (message.data['type'] == 'new_cite') {
      _showNotification(
          message.data['title'],
          message.data['name'],
          message.data['appointmentId']
      );
    }
  }

  static  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> _showNotification(String title, String name, String appointmentId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, 'Nombre: $name, Cita ID: $appointmentId', platformChannelSpecifics,
        payload: appointmentId);
  } */
}
