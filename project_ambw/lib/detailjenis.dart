// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';

class DetailJenis extends StatefulWidget {
  const DetailJenis({Key? key}) : super(key: key);

  @override
  State<DetailJenis> createState() => _DetailJenisState();
}

class _DetailJenisState extends State<DetailJenis> {
  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  CollectionReference categoryref =
      FirebaseFirestore.instance.collection("tabelJenis");

  Future<void> addCategory(listname) {
    int c = 0;
    for (int i = 0; i < listname.length; i++) {
      if (listname[i].toString() == namaController.text.toString()) {
        c = 1;
      }
    }
    if (c == 0) {
      Navigator.pop(context);
      return categoryref
          .add({
            'emailUser': FirebaseAuth.instance.currentUser!.email.toString(),
            'namaJenis': namaController.text,
            'deskripsiJenis': deskripsiController.text,
          })
          .then((value) => print("Category Added"))
          .catchError((error) => print("Failed to add Category: $error"));
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Category name already exists!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok!"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    deskripsiController.dispose();
  }

  List<String> listname = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Detail Jenis",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Inventory App | Detail Jenis"),
          centerTitle: true,
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
          margin: EdgeInsets.all(8),
          child: Center(
            child: Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: namaController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Input Nama!";
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Jenis',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: deskripsiController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Input Deskripsi!";
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deskripsi Jenis',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("tabelJenis")
                        .where("emailUser",
                            isEqualTo: FirebaseAuth.instance.currentUser?.email
                                .toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.requireData;
                      listname.clear();
                      if (snapshot.hasData) {
                        for (int i = 0; i < data.size; i++) {
                          listname.add(data.docs[i]['namaJenis']);
                        }
                        return ElevatedButton(
                          onPressed: () {
                            addCategory(listname);
                          },
                          child: Text("Add Jenis"),
                        );
                      }
                      return Container();
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
