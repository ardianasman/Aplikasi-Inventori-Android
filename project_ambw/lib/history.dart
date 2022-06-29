import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class myHistory extends StatefulWidget {
  const myHistory({Key? key}) : super(key: key);

  @override
  State<myHistory> createState() => _myHistoryState();
}

class _myHistoryState extends State<myHistory> {
  Query<Map<String, dynamic>> dbHistory = FirebaseFirestore.instance
      .collection("tabelHistory")
      .where('emailUser',
          isEqualTo: FirebaseAuth.instance.currentUser!.email.toString());

  Stream<QuerySnapshot> getData() {
    return dbHistory.snapshots();
  }

  int jumData = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          } else if (snapshot.hasData || snapshot.data != null) {
            return Container(
              padding: EdgeInsets.all(8),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  String namaBarang = data['namaBarang'];
                  String tanggal = data['tanggal'];
                  String tipe = data['tipe'];
                  jumData = snapshot.data!.docs.length;
                  return Card(
                    elevation: 10.0,
                    child: ListTile(
                      title: Text(namaBarang),
                      subtitle: Text(tanggal),
                      tileColor: tipe.toLowerCase() == "masuk"
                          ? Colors.green
                          : Colors.red,
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.pinkAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}
