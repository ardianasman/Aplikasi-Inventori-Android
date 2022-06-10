import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Supplier extends StatefulWidget {
  const Supplier({Key? key}) : super(key: key);

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App - Supplier",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Supplier - Inventory App"),
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
              Text("Ini halaman supplier"),
            ],
          ),
        ),
      ),
    );
  }
}
