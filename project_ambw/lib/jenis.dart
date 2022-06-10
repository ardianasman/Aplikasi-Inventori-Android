import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Jenis extends StatefulWidget {
  const Jenis({Key? key}) : super(key: key);

  @override
  State<Jenis> createState() => _JenisState();
}

class _JenisState extends State<Jenis> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App - Jenis",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Jenis - Inventory App"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Logged out from ${FirebaseAuth.instance.currentUser?.email}!',
                    ),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Text("Ini halaman jenis"),
            ],
          ),
        ),
      ),
    );
  }
}
