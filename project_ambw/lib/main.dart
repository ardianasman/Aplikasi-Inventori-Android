// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_ambw/profile.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Inventory',
      home: AnimatedSplashScreen(
        duration: 5000,
        splash: Icon(
          Icons.inventory_sharp,
          color: Colors.white,
          size: 150,
        ),
        nextScreen: MainScreen(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Color(0xFF264653),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 3){
        Navigator.push(context,
        MaterialPageRoute(builder: (builder) => Profile()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Inventory App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App"),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Text("Inventory App for Project AMBW"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      ),
    );
  }
}