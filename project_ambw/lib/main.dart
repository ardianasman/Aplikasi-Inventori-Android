// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_ambw/authpage.dart';
import 'package:project_ambw/firebase_options.dart';
import 'package:project_ambw/jenis.dart';
import 'package:project_ambw/home.dart';
import 'package:project_ambw/profile.dart';
import 'package:project_ambw/supplier.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'App Inventory',
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Icon(
          Icons.inventory_sharp,
          color: Colors.white,
          size: 150,
        ),
        nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong!");
            } else if (snapshot.hasData) {
              print("snapshot has data");
              return MainPage();
            } else {
              print("snapshot hasn't data");
              return AuthPage();
            }
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Color(0xFF264653),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentindex = 0;
  final pageList = [
    Home(),
    Supplier(),
    Jenis(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: currentindex,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentindex,
          onTap: (index) => setState(() => currentindex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          selectedFontSize: 16,
          unselectedItemColor: Colors.white70,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              tooltip: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.factory),
              label: "Supplier",
              tooltip: "Supplier",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Category",
              tooltip: "Category",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: "Profile",
              tooltip: "Profile - ${FirebaseAuth.instance.currentUser?.email}",
            ),
          ],
        ),
      ),
    );
  }
}
