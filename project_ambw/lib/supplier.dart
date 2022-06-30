// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/dataClass/classSupplier.dart';
import 'package:project_ambw/dataClass/dbservices.dart';
import 'package:project_ambw/detailsupplier.dart';

import 'dataClass/storageservice.dart';

class MyData {
  String NmSupplier;
  String AlSupplier;
  String NmBarang;
  String GambarBarang;
  MyData(this.NmSupplier, this.AlSupplier, this.NmBarang, this.GambarBarang);
}

class Supplier extends StatefulWidget {
  const Supplier({Key? key}) : super(key: key);

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final formKey = GlobalKey<FormState>();
  late List<MyData> list = [];
  TextEditingController namaController = TextEditingController();
  TextEditingController tmpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController namabarangController = TextEditingController();
  TextEditingController gambarbarangController = TextEditingController();

  final Storage storage = Storage();
  CollectionReference supplierref =
      FirebaseFirestore.instance.collection("tabelSupplier");

  Future editSupplier() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: ((context, setState) => AlertDialog(
                title: Text("Edit Supplier"),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: namaController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama Supplier',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: alamatController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Alamat Supplier',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: namabarangController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama Barang',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: Text('Save Data Supplier'),
                            onPressed: () {
                              int c = 0;

                              FirebaseFirestore.instance
                                  .collection("tabelSupplier")
                                  .where('namaSupplier',
                                      isEqualTo: tmpController.text)
                                  .where('emailUser',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString())
                                  .snapshots()
                                  .listen(
                                (event) {
                                  if (c == 0) {
                                    final dtSupplier = DataSupplier(
                                      nama: namaController.text,
                                      emailuser: FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString(),
                                      alamat: alamatController.text,
                                      namabarang: namabarangController.text,
                                      gambarSupplier: "",
                                    );
                                    Database.deleteSupplier(
                                        supplierid:
                                            event.docs[0].id.toString());
                                    supplierref.add({
                                      'emailUser': FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString(),
                                      'namaSupplier': namaController.text,
                                      'alamatSupplier': alamatController.text,
                                      'namaBarang': namabarangController.text,
                                    });
                                    c = 1;
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      );

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
        body: StreamBuilder<QuerySnapshot>(
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
            list.clear();
            for (int i = 0; i < data.size; i++) {
              if (data.docs[i]['emailUser'] ==
                  FirebaseAuth.instance.currentUser!.email.toString()) {
                list.add(
                  MyData(
                    data.docs[i]['namaSupplier'],
                    data.docs[i]['alamatSupplier'],
                    data.docs[i]['namaBarang'],
                    data.docs[i]['foto'],
                  ),
                );
              }
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    extentRatio: 0.2,
                    children: [
                      SlidableAction(
                        onPressed: ((context) {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection("tabelSupplier")
                                .where('namaSupplier',
                                    isEqualTo: list[index].NmSupplier)
                                .where('alamatSupplier',
                                    isEqualTo: list[index].AlSupplier)
                                .where('emailUser',
                                    isEqualTo: FirebaseAuth
                                        .instance.currentUser!.email
                                        .toString())
                                .snapshots()
                                .listen((event) {
                              print(event.docs[0].id.toString());
                              FirebaseFirestore.instance
                                  .collection("tabelSupplier")
                                  .doc(event.docs[0].id.toString())
                                  .delete();
                            });
                          });
                        }),
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.lightBlue),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: () {
                          namaController.text = list[index].NmSupplier;
                          tmpController.text = list[index].NmSupplier;
                          alamatController.text = list[index].AlSupplier;
                          namabarangController.text = list[index].NmBarang;
                          editSupplier();
                        },
                        leading: FutureBuilder(
                          future: storage.downloadURL(data.docs[index]['foto']),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                  radius: 75,
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        title: Text(list[index].NmSupplier),
                        subtitle: Text(list[index].AlSupplier),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSupplier(),
              ),
            );
            //list.clear();
          },
          tooltip: 'Add data',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
