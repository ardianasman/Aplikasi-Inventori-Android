import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'classUser.dart';

CollectionReference tabelUser =
    FirebaseFirestore.instance.collection("tabelUser");

class Database {
  static Stream<QuerySnapshot> getData() {
    return tabelUser.snapshots();
  }

  static Future<void> tambahData({required dataUser user}) async {
    DocumentReference docRef = tabelUser.doc(user.nama);

    await docRef
        .set(user.toJson())
        .whenComplete(() => print("Data berhasil register"))
        .catchError((e) => print(e));
  }

  static Future<void> updateData({required dataUser user}) async {
    DocumentReference docRef = tabelUser.doc(user.nama);

    await docRef
        .update(user.toJson())
        .whenComplete(() => print("Data berhasil update"))
        .catchError((e) => print(e));
  }
}
