import 'package:flutter/material.dart';
import 'package:project_ambw/jenis.dart';
import 'package:project_ambw/main.dart';
import 'package:project_ambw/profile.dart';
import 'package:project_ambw/supplier.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentTab = 0;
  List<Widget> pageList = <Widget>[
    MainScreen(),
    Jenis(),
    Supplier(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentTab],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                tooltip: "Home",
                color: currentTab == 0 ? Colors.blue : Colors.grey,
                onPressed: () {
                  setState(() {
                    currentTab = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.factory),
                color: currentTab == 1 ? Colors.blue : Colors.grey,
                tooltip: "Supplier",
                onPressed: () {
                  setState(() {
                    currentTab = 1;
                  });
                },
              ),
              SizedBox(width: 40), // The dummy child
              IconButton(
                icon: Icon(Icons.list),
                color: currentTab == 2 ? Colors.blue : Colors.grey,
                tooltip: "Category",
                onPressed: () {
                  setState(() {
                    currentTab = 2;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle_outlined),
                color: currentTab == 3 ? Colors.blue : Colors.grey,
                tooltip: "Profile",
                onPressed: () {
                  setState(() {
                    currentTab = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
