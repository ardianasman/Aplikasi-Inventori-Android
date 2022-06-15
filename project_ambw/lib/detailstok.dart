// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';

class DetailStok extends StatefulWidget {
  const DetailStok({Key? key}) : super(key: key);

  @override
  State<DetailStok> createState() => _DetailStokState();
}

class _DetailStokState extends State<DetailStok> {
  TextEditingController namaController = TextEditingController();
  TextEditingController jenisController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();

  late List<String> listjenis = [];
  late String _selectedjenis = "1";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Detail Stok",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Inventory App | Detail Stok"),
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Barang',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: jumlahController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah Barang',
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tabelJenis")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No Data");
                  } else if (snapshot.hasData) {
                    DocumentSnapshot ds;
                    for (int i = 0; i < snapshot.data!.size; i++) {
                      DocumentSnapshot dss = snapshot.data!.docs[i];
                      print(dss['namaJenis']);
                      listjenis.add(dss.data().toString());
                      print("done add");
                      print(listjenis);
                    }
                    return Container(
                      width: size.width,
                      color: Colors.red,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: DropdownButton(
                        dropdownColor: Colors.blue,
                        hint: Text("Pilih Jenis Barang"),
                        onChanged: (value) {
                          _selectedjenis = value.toString();
                          setState(() {
                            _selectedjenis;
                            print(_selectedjenis);
                          });
                        },
                        value: _selectedjenis,
                        items: listjenis
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
