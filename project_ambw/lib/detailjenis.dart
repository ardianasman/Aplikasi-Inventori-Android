import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';

class DetailJenis extends StatefulWidget {
  const DetailJenis({Key? key}) : super(key: key);

  @override
  State<DetailJenis> createState() => _DetailJenisState();
}

class _DetailJenisState extends State<DetailJenis> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Detail Jenis",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Inventory App | Detail Jenis"),
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
          child: Column(
            children: [
              Text("Ini halaman detail jenis"),
            ],
          ),
        ),
      ),
    );
  }
}
