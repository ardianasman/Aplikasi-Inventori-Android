// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | About Us",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Inventory App | About Us"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.lightBlue),
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 10,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "About Us",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Aplikasi inventori mobile yang hadir untuk memenuhi kebutuhan setiap pengguna dalam mengelola binsis",
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Fitur - fitur",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Inventory",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Supplier",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Category",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
