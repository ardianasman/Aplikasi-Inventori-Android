import 'package:flutter/material.dart';

import 'jenis.dart';

class editJenis extends StatefulWidget {
  MyData List;
  editJenis(this.List, {Key? key}) : super(key: key);

  @override
  State<editJenis> createState() => _editJenisState();
}

class _editJenisState extends State<editJenis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: ListView(
            children: [
              Text("Name Supplier:" + widget.List.NmJenis.toString()),
              Text("Supplier Address:" + widget.List.DkJenis.toString()),
            ],
          ),
        ));
  }
}
