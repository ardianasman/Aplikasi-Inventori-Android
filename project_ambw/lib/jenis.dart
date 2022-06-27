// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/dataClass/classJenis.dart';
import 'package:project_ambw/dataClass/dbservices.dart';
import 'package:project_ambw/detailjenis.dart';

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
  final formKey = GlobalKey<FormState>();
  late List<MyData> list = [];
  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController tmpController = TextEditingController();

  CollectionReference jenisref =
      FirebaseFirestore.instance.collection("tabelJenis");

  Future editJenis() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: ((context, setState) => AlertDialog(
                title: Text("Edit Jenis"),
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
                              labelText: 'Nama Jenis',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: deskripsiController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Deskripsi Jenis',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                              child: Text('Save Data Jenis'),
                              onPressed: () {
                                int c = 0;

                                FirebaseFirestore.instance
                                    .collection("tabelJenis")
                                    .where('namaJenis',
                                        isEqualTo: tmpController.text)
                                    .where('emailUser',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.email
                                            .toString())
                                    .snapshots()
                                    .listen((event) {
                                  if (c == 0) {
                                    final dtJenis = DataJenis(
                                        nama: namaController.text,
                                        emailuser: FirebaseAuth
                                            .instance.currentUser!.email
                                            .toString(),
                                        deskripsi: deskripsiController.text);
                                    Database.deleteJenis(
                                        supplierid:
                                            event.docs[0].id.toString());
                                    jenisref.add({
                                      'emailUser': FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString(),
                                      'namaJenis': namaController.text,
                                      'deskripsiJenis':
                                          deskripsiController.text,
                                    });
                                    c = 1;
                                    Navigator.pop(context);
                                  }
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ))));

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
              list.clear();
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
                    return Slidable(
                      endActionPane: ActionPane(
                          motion: DrawerMotion(),
                          extentRatio: 0.2,
                          children: [
                            SlidableAction(
                              onPressed: ((context) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection("tabelJenis")
                                      .where('namaJenis',
                                          isEqualTo: list[index].NmJenis)
                                      .where('deskripsiJenis',
                                          isEqualTo: list[index].DkJenis)
                                      .where('emailUser',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.email
                                              .toString())
                                      .snapshots()
                                      .listen((event) {
                                    print(event.docs[0].id.toString());
                                    FirebaseFirestore.instance
                                        .collection("tabelJenis")
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
                          ]),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            tmpController.text = list[index].NmJenis;
                            namaController.text = list[index].NmJenis;
                            deskripsiController.text = list[index].DkJenis;
                            editJenis();
                          },
                          title: Text(list[index].NmJenis),
                          subtitle: Text(list[index].DkJenis),
                        ),
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
            list.clear();
          },
          tooltip: 'Add data',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
