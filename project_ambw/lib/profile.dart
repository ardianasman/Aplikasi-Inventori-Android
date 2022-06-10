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
      title: "Profile",
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.red,
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Text(
                            "Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 75,
              ),
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
                  ElevatedButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
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
