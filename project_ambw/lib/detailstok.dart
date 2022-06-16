// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:intl/intl.dart';

class DetailStok extends StatefulWidget {
  const DetailStok({Key? key}) : super(key: key);

  @override
  State<DetailStok> createState() => _DetailStokState();
}

class _DetailStokState extends State<DetailStok> {
  TextEditingController namaController = TextEditingController();
  TextEditingController jenisController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime now = DateTime.now();
  String formatteddate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  CollectionReference jenisref =
      FirebaseFirestore.instance.collection("tabelJenis");
  CollectionReference supplierref =
      FirebaseFirestore.instance.collection("tabelSupplier");

  late List<String> listjenis = [];
  late List<String> listdesc = [];
  late List<String> listnamasup = [];
  late List<String> listalamatsup = [];

  late int c = 0;
  late int cx = 0;

  @override
  void initState() {
    super.initState();
    dateController = new TextEditingController(text: formatteddate);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Add Stok",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Inventory App | Add Stok"),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Input Nama!";
                    }
                  },
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
                    labelText: 'Jumlah Barang',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: hargaController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Input Harga!";
                    } else if (val.toString() == "0") {
                      return "Cant be 0";
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Harga Barang',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
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
                            if (ds[i]["emailUser"] == "zzz@gmail.com") {
                              listjenis.add(ds[i]["namaJenis"]);
                              listdesc.add(ds[i]["deskripsiJenis"]);
                              c = 1;
                            }
                          }
                        }
                        return showJenis();
                      }
                    } else {
                      return showJenis();
                    }
                  }),
              FutureBuilder(
                  future: supplierref.get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (cx != 1) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          List<QueryDocumentSnapshot<Object?>> ds =
                              snapshot.data!.docs;
                          for (int j = 0; j < ds.length - 1; j++) {
                            if (ds[i]["emailUser"] == "zzz@gmail.com") {
                              listnamasup.add(ds[i]["namaSupplier"]);
                              listalamatsup.add(ds[i]["alamatSupplier"]);
                              cx = 1;
                            }
                          }
                        }
                        print(listnamasup);
                        return showSupplier();
                      }
                    } else {
                      return showSupplier();
                    }
                  }),
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
            ]),
          ),
        ),
      ),
    );
  }

  Widget showSupplier() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Autocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return listnamasup.where((element) => element
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
              hintText: "Pilih Supplier",
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
                  subtitle: Text(listalamatsup[index]),
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
                  subtitle: Text(listdesc[index]),
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
