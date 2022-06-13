// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/dataClass/classUser.dart';
import 'package:project_ambw/dataClass/dbservices.dart';
import 'package:project_ambw/home.dart';
import 'package:project_ambw/login.dart';
import 'package:project_ambw/main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obsecureText = true;
  bool _obsecureTextConfirm = true;
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordconfirmController = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_sharp,
                        color: Colors.blue,
                        size: 50,
                      ),
                      Text(
                        'Inventory App',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // ignore: prefer_const_constructors
                  child: TextFormField(
                    controller: emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Email Cant be empty";
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // ignore: prefer_const_constructors
                  child: TextFormField(
                    controller: namaController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Name Cant be empty";
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // ignore: prefer_const_constructors
                  child: TextFormField(
                    obscureText: _obsecureText,
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password Cant be empty";
                      } else if (val.length < 8) {
                        return "Password must be atleast 8 characters long";
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        icon: Icon(
                          _obsecureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    obscureText: _obsecureTextConfirm,
                    controller: passwordconfirmController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Confirm Password Cant be empty";
                      } else if (val != passwordController.text) {
                        return "Password not match";
                      } else {
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        final userBaru = dataUser(
                            email: emailController.text,
                            nama: namaController.text,
                            password: passwordController.text,
                            nomer: "Not set",
                            alamatgudang: "Not set",
                            imagepath: "Not set");
                        Database.tambahData(user: userBaru);
                        Navigator.pop(context);
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecureTextConfirm = !_obsecureTextConfirm;
                          });
                        },
                        icon: Icon(
                          _obsecureTextConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      _form.currentState?.validate();
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    const Text('Already have account?'),
                    TextButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        //login screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => LoginPage()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            )),
      ),
    );
  }
}
