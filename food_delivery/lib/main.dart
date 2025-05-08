import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/pages/splash_screen.dart';
import 'package:food_delivery/service/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if(kIsWeb) {
     await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDgsPO4_zGo276K9ZlQ3LNmG7tm6d-xSqQ",
        appId: "1:1024277013397:web:68995a4e52a7852a2b8c9c",
        messagingSenderId: "1024277013397",
        projectId: "foodapp-92083",
        authDomain: "foodapp-92083.firebaseapp.com", // only for web
        storageBucket: "foodapp-92083.firebasestorage.app",
        measurementId: "G-44PHM71E1M", // only for web
      ),
    );
  } else{
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? "";
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(NotificationService.handleBackgroundMessage);

  await NotificationService.initialize();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}