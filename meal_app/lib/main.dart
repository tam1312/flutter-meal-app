import 'package:flutter/material.dart';
import 'package:meal_app/screens/home_screen.dart';
import 'package:meal_app/services/favorites_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meal_app/screens/recipe_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (_) => FavoritesService(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState () {
    super.initState();
    setupFCM();
  }

  //setup for firebase cloud messaging notifications
  Future<void> setupFCM() async {
    //ask user permission for notifications
    //await FirebaseMessaging.instance.requestPermission();

    //check if notifications are enabled 
    final permission = await FirebaseMessaging.instance.requestPermission();
    debugPrint('Authorization status: ${permission.authorizationStatus}');

    //get FirebaseCloudMessaging token (registration token)
    final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BJOlXXD7OnHLahpoOXrthplxY140_kvaEJgLX0kvFEEGUDf60Io0amsqdy9SRWdoaXspuvPJ5lATJReUzifMDj8");
    debugPrint('fcm token: $fcmToken');

    //listen for foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Notification received: ${message.notification?.title}');
    });

    //for when the app's been running in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _openRandomRecipeScreen();
    });

    //for when app is closed (terminated)
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _openRandomRecipeScreen();
    }

  }

  // opens a random recipe screen when user clicks on notification
  void _openRandomRecipeScreen () {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (BuildContext context) => RecipeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal App',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: "/",
      routes: {
        "/": (context) =>  MyHomePage(title: 'Meal App'), 
      },
    );
  }
}

