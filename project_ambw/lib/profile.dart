// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User currentuser;
  final String? currentUser = FirebaseAuth.instance.currentUser?.email;

  void logOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Logged out from $currentUser!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                      ),
                    )
                  ],
                ),
              );
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Profile",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App | Profile"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  logOut();
                },
                icon: Icon(Icons.logout),
              ),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 115,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text("nama"),
                          Text("nomer"),
                          Text(currentUser.toString()),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      logOut();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
