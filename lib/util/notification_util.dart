import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtility {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationChannel? channel;
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  Future<void> initFirebaseNotification() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'fcm_notification',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    setupLocalNotification(flutterLocalNotificationsPlugin);
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel!);
    } else {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    }
    
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    Future.wait([
      initListenBackgroundNotification(),
      initListenOpenBackgroundNotification()
    ]);
  }

  Future<void> initListenOpenBackgroundNotification() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      try {
        
      } catch (e) {
        log(e.toString());
      }
    });
  }

  Future<void> initListenBackgroundNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then((message){
      print(message);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showFlutterNotification(message);
    });
  }

  void setupLocalNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    var initializationSettingsAndroid = const AndroidInitializationSettings('mipmap/ic_launcher');
      var initializationSettingsIOS = const DarwinInitializationSettings(requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
      var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) {
      // event open in app
    }, );
  }


  void showFlutterNotification(RemoteMessage message){
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel?.id ?? '',
        channel?.name ?? '',
        importance: Importance.max,
        ticker: 'ticker',
        priority: Priority.high,
        color: Colors.amber,
        colorized: true,
        icon: '@mipmap/ic_launcher',
        channelDescription: channel?.description ?? '',
      );

      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformChannelSpecifics,
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler (RemoteMessage message) async{
  // listen at background 
  
}