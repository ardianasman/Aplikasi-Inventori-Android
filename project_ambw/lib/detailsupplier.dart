// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/dataClass/storageservice.dart';

class DetailSupplier extends StatefulWidget {
  const DetailSupplier({Key? key}) : super(key: key);

  @override
  State<DetailSupplier> createState() => _DetailSupplierState();
}

class _DetailSupplierState extends State<DetailSupplier> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController barangController = TextEditingController();
  CollectionReference supplierref =
      FirebaseFirestore.instance.collection("tabelSupplier");

  Future<void> addSupplier(listname) {
    int c = 0;
    for (int i = 0; i < listname.length; i++) {
      if (listname[i].toString() == namaController.text.toString()) {
        c = 1;
      }
    }
    if (c == 0) {
      Navigator.pop(context);
      return supplierref
          .add({
            'emailUser': FirebaseAuth.instance.currentUser!.email.toString(),
            'namaSupplier': namaController.text,
            'alamatSupplier': alamatController.text,
            'foto': tmppath,
            'namaBarang': barangController.text
          })
          .then((value) => print("Supplier Added"))
          .catchError((error) => print("Failed to add Supplier: $error"));
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Supplier name already exists!"),
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

  void picker() async {
    final results = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (results == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No File Selected")));
    }

    final editpath = results!.files.single.path;
    final editname = results.files.single.name;
    setState(() {
      tmppath = editname;
      print("tmp = " + tmppath);
    });
  }

  Widget displayImage() {
    return GestureDetector(
        onTap: () {
          picker();
        },
        child: FutureBuilder(
            future: storage.downloadURL(tmppath),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                print("tmpname = " + tmppath);
                return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!),
                  radius: 75,
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    alamatController.dispose();
  }

  List<String> listname = [];
  Storage storage = Storage();
  String tmppath = "default-avatar.jpg";

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
              displayImage(),
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
                child: TextFormField(
                  controller: barangController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Input Barang!";
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Barang',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("tabelSupplier")
                        .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.requireData;
                      listname.clear();
                      if (snapshot.hasData) {
                        for (int i = 0; i < data.size; i++) {
                          listname.add(data.docs[i]['namaSupplier']);
                        }
                        return ElevatedButton(
                          onPressed: () {
                            addSupplier(listname);
                          },
                          child: Text("Add Supplier"),
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
