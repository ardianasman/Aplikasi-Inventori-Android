// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/dataClass/classInventori.dart';
import 'package:project_ambw/dataClass/storageservice.dart';
import 'package:project_ambw/detailstok.dart';
import 'package:project_ambw/detailstokcard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<DataInventori> list = [];
  late List<String> docID = [];
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double itemHeight = (_size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = _size.width / 2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Home",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App | Home"),
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
            stream: FirebaseFirestore.instance
                .collection("tabelInventori")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Somenthing Wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              final data = snapshot.requireData;
              list.clear();
              docID.clear();
              for (int i = 0; i < data.size; i++) {
                if (data.docs[i]['emailUser'] ==
                    FirebaseAuth.instance.currentUser!.email.toString()) {
                  list.add(DataInventori(
                      nama: data.docs[i]["namaBarang"],
                      foto: data.docs[i]["fotoBarang"],
                      jenis: data.docs[i]["jenisBarang"],
                      supplier: data.docs[i]["supplierBarang"],
                      harga: data.docs[i]["hargaBarang"],
                      jumlah: data.docs[i]["jumlahBarang"],
                      tanggalmasuk: data.docs[i]["tanggalMasukBarang"]));
                  docID.add(data.docs[i].id);
                }
              }
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.shortestSide < 600
                              ? 2
                              : 4),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        print(docID[index]);
                        FirebaseFirestore.instance
                            .collection("tabelInventori")
                            .doc(docID[index].toString())
                            .delete();
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailStokCard(ind: docID[index]),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Column(
                              children: [
                                FutureBuilder(
                                    future:
                                        storage.downloadURL(list[index].foto),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(snapshot.data!),
                                          radius: 50,
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
                                SizedBox(height: 7.0),
                                Text(
                                  list[index].nama,
                                  style: TextStyle(
                                    color: Color(0xFF575E67),
                                    fontFamily: 'Varela',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  list[index].harga,
                                  style: TextStyle(
                                    color: Color(0xFFCC8053),
                                    fontFamily: 'Varela',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                builder: (context) => DetailStok(),
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
