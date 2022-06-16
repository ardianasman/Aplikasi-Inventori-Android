// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  CollectionReference jenisref =
      FirebaseFirestore.instance.collection("tabelJenis");

  late List<String> listjenis = [];

  late int c = 0;

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
              FutureBuilder(
                  future: jenisref.get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (c != 1) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          List<QueryDocumentSnapshot<Object?>> ds =
                              snapshot.data!.docs;
                          for (int j = 0; j < ds.length - 1; j++) {
                            listjenis.add(ds[i]["namaJenis"]);
                            c = 1;
                          }
                        }
                        return showJenis();
                      }
                    } else {
                      return showJenis();
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }

  Widget showJenis() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Autocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return listjenis.where((element) => element
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
        },
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: "Pilih Jenis Barang",
            ),
          );
        },
        onSelected: (selectedjenis) {
          print(selectedjenis);
        },
        optionsViewBuilder: (context, Function(String) onSelected, options) {
          return Material(
            elevation: 4,
            child: ListView.separated(
              separatorBuilder: ((context, index) => Divider()),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);

                return ListTile(
                  title: Text(option.toString()),
                  subtitle: Text("This is sub"),
                  onTap: () {
                    onSelected(option.toString());
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
