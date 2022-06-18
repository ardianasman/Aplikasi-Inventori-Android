// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
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

  Future editJenis() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: ((context, setState) => AlertDialog(
                title: Text("Edit Profile"),
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
                            readOnly: true,
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
                                // final dtUpdate = DataUser(
                                //     email: emailController.text,
                                //     nama: namaController.text,
                                //     password: passwordController.text,
                                //     nomer: nomerController.text,
                                //     alamatgudang: gudangController.text,
                                //     imagepath: imagepath.text);
                                // Database.delete(nama: tmpnama);
                                // Database.tambahData(user: dtUpdate);

                                // Navigator.pop(context);
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
                          namaController.text = list[index].NmJenis;
                          deskripsiController.text = list[index].DkJenis;
                          editJenis();
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
