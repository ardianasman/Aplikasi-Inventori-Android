import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User currentuser;
  final String? currentUser = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App - Profile",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile - Inventory App"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Logged out from $currentuser!',
                    ),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Icon(
                            Icons.account_circle,
                            size: 115,
                          ),
                        ],
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
                    ],
                  ),
                  ElevatedButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Logged out from $currentuser!',
                          ),
                        ),
                      );
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
