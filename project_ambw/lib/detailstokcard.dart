import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ambw/dataClass/classInventori.dart';

import 'aboutus.dart';
import 'dataClass/storageservice.dart';

class DetailStokCard extends StatefulWidget {
  final String ind;
  const DetailStokCard({Key? key, required this.ind}) : super(key: key);

  @override
  State<DetailStokCard> createState() => _DetailStokCardState();
}

class _DetailStokCardState extends State<DetailStokCard> {
  TextEditingController dateController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController jenisController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController fotoController = TextEditingController();

  TextEditingController tmpController = TextEditingController();

  late String? newVal = "";

  late List<String> listJenis = [];
  late List<String> listSupplier = [];

  late int c;
  late int cj;
  late int cs;
  late int cd;

  final Storage storage = Storage();

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    c = 0;
    cj = 0;
    cs = 0;
    cd = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Detail Stok",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("tabelInventori")
                        .doc(widget.ind)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("No Data");
                      } else if (snapshot.hasData) {
                        if (c == 0) {
                          var output = snapshot.data!.data();
                          namaController.text =
                              output!["namaBarang"].toString();
                          tmpController.text = output!["namaBarang"].toString();
                          jumlahController.text =
                              output["jumlahBarang"].toString();
                          hargaController.text =
                              output["hargaBarang"].toString();
                          fotoController.text = output["fotoBarang"].toString();
                          jenisController.text =
                              output["jenisBarang"].toString();
                          supplierController.text =
                              output["supplierBarang"].toString();
                          if (c == 0) {
                            dateController.text =
                                output["tanggalMasukBarang"].toString();
                            c = 1;
                          }
                          now = DateFormat("yyyy-MM-dd")
                              .parse(dateController.text);
                          return showField();
                        }
                        return showField();
                      }
                      return Container();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showField() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: namaController,
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
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: jumlahController,
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
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: hargaController,
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
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tabelJenis")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (cj == 0) {
                    listJenis.clear();
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      if (snapshot.data!.docs[i]['emailUser'] ==
                          FirebaseAuth.instance.currentUser!.email.toString()) {
                        listJenis.add(snapshot.data!.docs[i]['namaJenis']);
                      }
                    }
                    print(listJenis);
                    cj = 1;
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 75,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: InputDecorator(
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: listJenis.map((e) {
                                return DropdownMenuItem<String>(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  jenisController.text = val.toString();
                                });
                              },
                              value: jenisController.text,
                              dropdownColor: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: InputDecorator(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: listJenis.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                jenisController.text = val.toString();
                              });
                            },
                            value: jenisController.text,
                            dropdownColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tabelSupplier")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (cs == 0) {
                    listSupplier.clear();
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      if (snapshot.data!.docs[i]['emailUser'] ==
                          FirebaseAuth.instance.currentUser!.email.toString()) {
                        listSupplier
                            .add(snapshot.data!.docs[i]['namaSupplier']);
                      }
                    }
                    print(listSupplier);
                    cs = 1;
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 75,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: InputDecorator(
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: listSupplier.map((e) {
                                return DropdownMenuItem<String>(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  supplierController.text = val.toString();
                                });
                              },
                              value: supplierController.text,
                              dropdownColor: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: InputDecorator(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: listSupplier.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                supplierController.text = val.toString();
                              });
                            },
                            value: supplierController.text,
                            dropdownColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  child: Icon(Icons.calendar_month),
                  onTap: () async {
                    cd = 0;
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));
                    if (newDate == null) {
                      return;
                    }
                    setState(() {
                      if (cd == 0) {
                        String formatteddatex =
                            DateFormat('yyyy-MM-dd').format(newDate);
                        dateController.text = formatteddatex;
                        now = newDate;
                        cd = 1;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              CollectionReference inventoriref =
                  FirebaseFirestore.instance.collection("tabelInventori");
              inventoriref
                  .where("namaBarang", isEqualTo: tmpController.text)
                  .where("emailUser",
                      isEqualTo:
                          FirebaseAuth.instance.currentUser?.email.toString())
                  .snapshots()
                  .listen((event) {
                print(event.docs[0].id.toString());
                //inventoriref.doc(event.docs[0].id.toString()).delete();
                inventoriref
                    .doc(event.docs[0].id.toString())
                    .update({
                      'emailUser':
                          FirebaseAuth.instance.currentUser!.email.toString(),
                      'fotoBarang': "default-avatar.jpg",
                      'hargaBarang': hargaController.text,
                      'jenisBarang': jenisController.text,
                      'jumlahBarang': jumlahController.text,
                      'namaBarang': namaController.text,
                      'supplierBarang': supplierController.text,
                      'tanggalMasukBarang': dateController.text,
                    })
                    .then((value) => print("Inventory Added"))
                    .catchError(
                        (error) => print("Failed to add Inventory: $error"));
              });

              Navigator.pop(context);
            },
            child: Text("Edit Stok"),
          ),
        ],
      ),
    );
  }

  bool cek(String x) {
    if (x == FirebaseAuth.instance.currentUser!.email.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
