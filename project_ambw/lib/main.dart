import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Inventory App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App"),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              
            ],
          ),
        ),
      )
    );
  }
}