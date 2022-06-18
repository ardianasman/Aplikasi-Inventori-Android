import 'package:flutter/material.dart';
import 'package:project_ambw/supplier.dart';

class editSupplier extends StatefulWidget {
  MyData List;
  editSupplier(this.List, {Key? key}) : super(key: key);

  @override
  State<editSupplier> createState() => _editSupplierState();
}

class _editSupplierState extends State<editSupplier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: ListView(
            children: [
              Text("Name Supplier:" + widget.List.NmSupplier.toString()),
              Text("Supplier Address:" + widget.List.AlSupplier.toString()),
            ],
          ),
        ));
  }
}
