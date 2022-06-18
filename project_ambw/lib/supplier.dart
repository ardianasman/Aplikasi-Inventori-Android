// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/dataClass/classInventori.dart';
import 'package:project_ambw/detailsupplier.dart';

class MyData {
  String NmSupplier;
  String AlSupplier;
  MyData(this.NmSupplier, this.AlSupplier);
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
  TextEditingController alamatController = TextEditingController();

  Future editSupplier() => showDialog(
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
                              labelText: 'Nama Supplier',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: alamatController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Alamat Supplier',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                              child: Text('Save Data SUpplier'),
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
                  list.add(MyData(data.docs[i]['namaSupplier'],
                      data.docs[i]['alamatSupplier']));
                }
              }
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          namaController.text = list[index].NmSupplier;
                          alamatController.text = list[index].AlSupplier;
                          editSupplier();
                        },
                        title: Text(list[index].NmSupplier),
                        subtitle: Text(list[index].AlSupplier),
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
