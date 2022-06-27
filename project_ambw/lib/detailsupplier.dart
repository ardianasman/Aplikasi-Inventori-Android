// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';

class DetailSupplier extends StatefulWidget {
  const DetailSupplier({Key? key}) : super(key: key);

  @override
  State<DetailSupplier> createState() => _DetailSupplierState();
}

class _DetailSupplierState extends State<DetailSupplier> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  CollectionReference supplierref =
      FirebaseFirestore.instance.collection("tabelSupplier");

  Future<void> addSupplier() {
    Navigator.pop(context);
    return supplierref
        .add({
          'emailUser': FirebaseAuth.instance.currentUser!.email.toString(),
          'namaSupplier': namaController.text,
          'alamatSupplier': alamatController.text,
        })
        .then((value) => print("Supplier Added"))
        .catchError((error) => print("Failed to add Supplier: $error"));
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    alamatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Detail Supplier",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Inventory App | Detail Supplier"),
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
                    labelText: 'Nama Supplier',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: alamatController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Input Alamat!";
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alamat Supplier',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  onPressed: () {
                    addSupplier();
                  },
                  child: Text("Add Supplier"),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
