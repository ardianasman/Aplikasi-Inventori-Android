// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/aboutus.dart';
import 'package:project_ambw/detailstok.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double itemHeight = (_size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = _size.width / 2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Home",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App | Home"),
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
        body: GridView.count(
          padding: EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: (itemWidth / itemHeight),
          children: [
            _buildCard(
              'Cookie mint',
              '\$3.99',
              'Assets/default-avatar.jpg',
            ),
            _buildCard(
              'Cookie cream',
              '\$5.99',
              'Assets/default-avatar.jpg',
            ),
            _buildCard(
              'Cookie classic',
              '\$1.99',
              'Assets/default-avatar.jpg',
            ),
            _buildCard(
              'Cookie choco',
              '\$2.99',
              'Assets/default-avatar.jpg',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailStok(),
              ),
            );
          },
          tooltip: 'Add data',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCard(String name, String price, String imgPath) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailStok(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Hero(
                  tag: imgPath,
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imgPath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Text(
                name,
                style: TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 14.0,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: Color(0xFFCC8053),
                  fontFamily: 'Varela',
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
