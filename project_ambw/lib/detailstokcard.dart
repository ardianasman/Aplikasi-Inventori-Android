import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_ambw/dataClass/classInventori.dart';
import 'package:path/path.dart' as Path;
import 'package:project_ambw/dataClass/dbservices.dart';

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
  CollectionReference inventoriref =
      FirebaseFirestore.instance.collection("tabelInventori");
  TextEditingController tmpController = TextEditingController();

  late String? newVal = "";

  late List<String> listJenis = [];
  late List<String> listSupplier = [];

  late int c;

  final Storage storage = Storage();

  DateTime now = DateTime.now();

  File? _image;
  final imgpicker = ImagePicker();
  void bukaGallery() async {
    var image = await imgpicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    c = 0;
  }

  Future<void> editStockCard() async {
    if (hargaController.text == '' &&
        jenisController.text == '' &&
        jumlahController.text == '' &&
        namaController.text == '' &&
        supplierController.text == '') {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Please fill all fields!"),
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
    } else {
      String fileName = Path.basename(_image!.path);
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('avatar/$fileName')
          .putFile(File(_image!.path));

      int c = 0;

      FirebaseFirestore.instance
          .collection("tabelInventory")
          .where('namaBarang', isEqualTo: tmpController.text)
          .where('emailUser',
              isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
          .snapshots()
          .listen((event) {
        if (c == 0) {
          final dtSupplier = DataInventori(
            nama: namaController.text,
            foto: fileName,
            jenis: jenisController.text,
            supplier: supplierController.text,
            harga: hargaController.text,
            jumlah: jumlahController.text,
            tanggalmasuk: dateController.text,
          );
          Database.deleteSupplier(supplierid: event.docs[0].id.toString());
          inventoriref.add({
            'emailUser': FirebaseAuth.instance.currentUser!.email.toString(),
            'fotoBarang': fileName,
            'hargaBarang': hargaController.text,
            'jenisBarang': jenisController.text,
            'jumlahBarang': jumlahController.text,
            'namaBarang': namaController.text,
            'supplierBarang': supplierController.text,
            'tanggalMasukBarang': dateController.text
          });
          c = 1;
          Navigator.pop(context);
        }
      });
    }
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
                        var output = snapshot.data!.data();
                        namaController.text = output!["namaBarang"].toString();
                        jumlahController.text =
                            output["jumlahBarang"].toString();
                        hargaController.text = output["hargaBarang"].toString();
                        fotoController.text = output["fotoBarang"].toString();
                        jenisController.text = output["jenisBarang"].toString();
                        supplierController.text =
                            output["supplierBarang"].toString();
                        if (c == 0) {
                          dateController.text =
                              output["tanggalMasukBarang"].toString();
                          c = 1;
                        }
                        now =
                            DateFormat("yyyy-MM-dd").parse(dateController.text);
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
          Padding(padding: EdgeInsets.all(8)),
          FutureBuilder(
            future: storage.downloadURL(fotoController.text),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                      radius: 75,
                    ),
                    onTap: () {
                      bukaGallery();
                      print(_image);
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
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
                  listJenis.clear();
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    if (snapshot.data!.docs[i]['emailUser'] ==
                        FirebaseAuth.instance.currentUser!.email.toString()) {
                      listJenis.add(snapshot.data!.docs[i]['namaJenis']);
                    }
                  }
                  print(listJenis);
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
                              jenisController.text = val.toString();
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
                  listSupplier.clear();
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    if (snapshot.data!.docs[i]['emailUser'] ==
                        FirebaseAuth.instance.currentUser!.email.toString()) {
                      listSupplier.add(snapshot.data!.docs[i]['namaSupplier']);
                    }
                  }
                  print(listSupplier);
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
                              jenisController.text = val.toString();
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
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));
                    if (newDate == null) {
                      return;
                    }
                    setState(() {
                      String formatteddatex =
                          DateFormat('yyyy-MM-dd').format(newDate);
                      dateController.text = formatteddatex;
                      now = newDate;
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: ElevatedButton(
              onPressed: () {
                editStockCard();
              },
              child: Text("Edit Data"),
            ),
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
