// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dataClass/dbservices.dart';

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
              Fluttertoast.showToast(
                msg: "Logged in as ${FirebaseAuth.instance.currentUser?.email}",
              );
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
        body: StreamBuilder<QuerySnapshot>(
            stream: Database.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                Text("Error");
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    DocumentSnapshot dsData = snapshot.data!.docs[index];
                    String lvNama = dsData['nama'];
                    String lvEmail = dsData['email'];
                    String lvNomer = dsData['nomer'];
                    return ListTile(
                      onTap: () {},
                      onLongPress: () {},
                      title: Text(lvNama),
                      subtitle: Text(lvEmail),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8,
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                );
              }
              return Container();
            }),
      ),
    );
  }
}
