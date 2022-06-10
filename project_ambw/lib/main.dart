// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_ambw/firebase_options.dart';
import 'package:project_ambw/login.dart';
import 'package:project_ambw/profile.dart';

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
        nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyApp();
            } else {
              return LoginPage();
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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int currentTab = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => Profile()));
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: Icon(Icons.add),
          elevation: 2.0,
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentTab == 0 ? Colors.blue : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentTab = 0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: currentTab == 1 ? Colors.blue : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentTab = 1;
                    });
                  },
                ),
                SizedBox(width: 40), // The dummy child
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: currentTab == 2 ? Colors.blue : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentTab = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  color: currentTab == 3 ? Colors.blue : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentTab = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //       backgroundColor: Colors.red,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.business),
        //       label: 'Business',
        //       backgroundColor: Colors.green,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.notifications),
        //       label: 'Notifications',
        //       backgroundColor: Colors.purple,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.account_circle),
        //       label: 'Profile',
        //       backgroundColor: Colors.pink,
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.amber[800],
        //   onTap: _onItemTapped,
        // ),
      ),
    );
  }
}
