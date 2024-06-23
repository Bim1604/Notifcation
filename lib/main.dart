import 'package:fire_base/screens/app.dart';
import 'package:fire_base/util/notification_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationUtility().initFirebaseNotification();
  runApp(const MyApp());
}
