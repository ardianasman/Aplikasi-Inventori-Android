import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_ambw/home.dart';
import 'package:project_ambw/main.dart';

import 'aboutus.dart';

class Keluar extends StatefulWidget {
  const Keluar({Key? key}) : super(key: key);

  @override
  State<Keluar> createState() => _KeluarState();
}

class _KeluarState extends State<Keluar> {
  late List<String> listbarang = [];
  TextEditingController selectedBarang = TextEditingController();
  TextEditingController minusBarang = TextEditingController();
  int c = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedBarang.text = "";
    c = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Inventory App | Detail Supplier",
        home: Scaffold(
          appBar: AppBar(
            title: Text("Inventory App | Keluar Barang"),
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
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("tabelInventori")
                          .where('emailUser',
                              isEqualTo: FirebaseAuth
                                  .instance.currentUser?.email
                                  .toString())
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("No Data!");
                        } else {
                          listbarang.clear();
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            listbarang
                                .add(snapshot.data!.docs[i]['namaBarang']);
                          }
                          print(listbarang);
                          if (selectedBarang.text == "") {
                            selectedBarang.text = listbarang[0];
                          }

                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 75,
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: listbarang.map((e) {
                                      return DropdownMenuItem<String>(
                                          value: e, child: Text(e));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedBarang.text = val.toString();
                                        print(selectedBarang.text);
                                      });
                                    },
                                    value: selectedBarang.text,
                                    dropdownColor: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextFormField(
                      controller: minusBarang,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Input Jumlah!";
                        } else if (val.toString() == "0") {
                          return "Cant be 0";
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jumlah Keluar Barang',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        CollectionReference inventoriref = FirebaseFirestore
                            .instance
                            .collection("tabelInventori");
                        inventoriref
                            .where("namaBarang", isEqualTo: selectedBarang.text)
                            .where("emailUser",
                                isEqualTo: FirebaseAuth
                                    .instance.currentUser?.email
                                    .toString())
                            .snapshots()
                            .listen((event) {
                          final totalakhir = int.parse(
                                  event.docs[0]["jumlahBarang"].toString()) -
                              int.parse(minusBarang.text.toString());
                          if (c == 0) {
                            inventoriref
                                .doc(event.docs[0].id.toString())
                                .update({
                                  'jumlahBarang': totalakhir.toString(),
                                })
                                .then((value) => print("Jumlah Updated"))
                                .catchError((error) =>
                                    print("Failed to add Inventory: $error"));
                            c = 1;
                            CollectionReference historyref = FirebaseFirestore
                                .instance
                                .collection("tabelHistory");
                            DateTime date = DateTime.now();
                            print("date = " + date.toString());
                            historyref.add({
                              'namaBarang': selectedBarang.text,
                              'tanggal': date.toString(),
                              'tipe': 'keluar',
                              'emailUser': FirebaseAuth
                                  .instance.currentUser?.email
                                  .toString()
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MainPage())));
                          }
                        });
                      },
                      child: Text("Minus Stok"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
