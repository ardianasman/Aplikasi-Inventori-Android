// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/dataClass/classInventori.dart';
import 'package:project_ambw/detailsupplier.dart';

class Supplier extends StatefulWidget {
  const Supplier({Key? key}) : super(key: key);

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  late List<String> listNmSupplier = [];
  late List<String> listAlSupplier = [];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> sup =
        FirebaseFirestore.instance.collection('tabelSupplier').snapshots();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Supplier",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App | Supplier"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                tooltip: "About Us",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUs(),
                    ),
                  );
                },
                icon: Icon(Icons.perm_device_information),
              ),
            ),
          ],
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: sup,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasError) {
                return Text("Somenthing Wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              final data = snapshot.requireData;

              for (int i = 0; i < data.size; i++) {
                if (data.docs[i]['emailUser'] ==
                    FirebaseAuth.instance.currentUser!.email.toString()) {
                  listNmSupplier.add(data.docs[i]['namaSupplier']);
                  listAlSupplier.add(data.docs[i]['alamatSupplier']);
                }
              }
              return ListView.builder(
                  itemCount: listNmSupplier.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(listNmSupplier[index]),
                        subtitle: Text(listAlSupplier[index]),
                      ),
                    );
                  });
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSupplier(),
              ),
            );
          },
          tooltip: 'Add data',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
