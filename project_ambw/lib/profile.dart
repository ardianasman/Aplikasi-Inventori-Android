// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/dataClass/classUser.dart';
import 'package:project_ambw/dataClass/storageservice.dart';

import 'dataClass/dbservices.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User currentuser;
  final String? currentUser = FirebaseAuth.instance.currentUser?.email;
  late String path = "Assets/default-avatar.jpg";
  final Storage storage = Storage();
  TextEditingController namaController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController nomerController = new TextEditingController();
  TextEditingController gudangController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();
  TextEditingController imagepath = new TextEditingController();
  late String tmpnama = "";

  bool obsecurePassword = true;
  bool obsecureConfirmPassword = true;

  late bool _isSaveButtonActive = true;

  final formKey = GlobalKey<FormState>();

  Future editProfile() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: ((context, setState) => AlertDialog(
                title: Text("Edit Profile"),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: namaController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: emailController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: nomerController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nomer Telepon',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: gudangController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Alamat Gudang',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                              child: Text('Save Profile'),
                              onPressed: () {
                                final dtUpdate = dataUser(
                                    email: emailController.text,
                                    nama: namaController.text,
                                    password: passwordController.text,
                                    nomer: nomerController.text,
                                    alamatgudang: gudangController.text,
                                    imagepath: imagepath.text);
                                Database.delete(nama: tmpnama);
                                Database.tambahData(user: dtUpdate);

                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ))));

  void logOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Logged out from $currentUser!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                      ),
                    )
                  ],
                ),
              );
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Widget displayProfile(users) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg']);
              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No File Selected")));
              }

              final editpath = results!.files.single.path;
              final editname = results.files.single.name;

              final dtUpdate = dataUser(
                  email: users['email'],
                  nama: users['nama'],
                  password: users['password'],
                  nomer: users['nomer'],
                  alamatgudang: users['alamatgudang'],
                  imagepath: editname);

              Database.updateData(user: dtUpdate);

              storage
                  .uploadFile(editpath.toString(), editname)
                  .then((value) => print("storage success"));
            },
            child: FutureBuilder(
              future: storage.downloadURL(users['imagepath']),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!),
                    radius: 75,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Text(users["nama"]),
          Text(users["email"]),
          Text(users["nomer"]),
          Text(users["alamatgudang"]),
          ElevatedButton(
            child: const Text('Edit Profile'),
            onPressed: () {
              namaController.text = users['nama'];
              tmpnama = users['nama'];
              emailController.text = users['email'];
              nomerController.text = users['nomer'];
              gudangController.text = users['alamatgudang'];
              passwordController.text = users['password'];
              passwordConfirmController.text = users['password'];
              imagepath.text = users['imagepath'];
              editProfile();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory App | Profile",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory App | Profile"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  logOut();
                },
                icon: Icon(Icons.logout),
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("tabelUser").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("No Data");
            } else if (snapshot.hasData) {
              DocumentSnapshot users, user;
              int tmpind = 0;
              print("curuser " + currentUser.toString());
              for (int i = 0; i < snapshot.data!.size; i++) {
                DocumentSnapshot users = snapshot.data!.docs[i];
                if (users['email'].toString().toLowerCase() == currentUser) {
                  tmpind = i;
                  print("tmpind " + tmpind.toString());
                }
              }
              user = snapshot.data!.docs[tmpind];
              return displayProfile(user);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
