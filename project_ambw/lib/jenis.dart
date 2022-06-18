// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/detailjenis.dart';
import 'package:project_ambw/editJenis.dart';

class MyData {
  String NmJenis;
  String DkJenis;
  MyData(this.NmJenis, this.DkJenis);
}

class Jenis extends StatefulWidget {
  const Jenis({Key? key}) : super(key: key);

  @override
  State<Jenis> createState() => _JenisState();
}

class _JenisState extends State<Jenis> {
  late List<MyData> list = [];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> sup =
        FirebaseFirestore.instance.collection('tabelJenis').snapshots();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Jenis",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App | Jenis"),
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
                  list.add(MyData(data.docs[i]['namaJenis'],
                      data.docs[i]['deskripsiJenis']));
                }
              }
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => editJenis(list[index])),
                          );
                        },
                        title: Text(list[index].NmJenis),
                        subtitle: Text(list[index].DkJenis),
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
                builder: (context) => DetailJenis(),
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
