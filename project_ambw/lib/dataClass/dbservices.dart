import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ambw/dataClass/classSupplier.dart';

import 'classUser.dart';

CollectionReference tabelUser =
    FirebaseFirestore.instance.collection("tabelUser");
CollectionReference tabelSupplier =
    FirebaseFirestore.instance.collection("tabelSupplier");

class Database {
  static Stream<QuerySnapshot> getData() {
    return tabelUser.snapshots();
  }

  static Future<void> tambahData({required DataUser user}) async {
    DocumentReference docRef = tabelUser.doc(user.nama);

    await docRef
        .set(user.toJson())
        .whenComplete(() => print("Data berhasil register"))
        .catchError((e) => print(e));
  }

  static Future<void> updateData({required DataUser user}) async {
    DocumentReference docRef = tabelUser.doc(user.nama);

    await docRef
        .update(user.toJson())
        .whenComplete(() => print("Data berhasil update"))
        .catchError((e) => print(e));
  }

  static Future<void> delete({required String nama}) async {
    DocumentReference docRef = tabelUser.doc(nama);

    await docRef
        .delete()
        .whenComplete(() => print("Data berhasil delete"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteSupplier({required String supplierid}) async {
    DocumentReference docRef = tabelSupplier.doc(supplierid);

    await docRef
        .delete()
        .whenComplete(() => print("Data berhasil delete"))
        .catchError((e) => print(e));
  }
}
