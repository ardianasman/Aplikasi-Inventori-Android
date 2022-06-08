import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:project_ambw/provider/google_sign.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: "Login",
        home: Scaffold(
          body: Container(
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    // provider.googleLogin();
                    // await _googleSignIn.signIn();
                    // setState(() {
                      
                    // });
                  },
                  child: Icon(Icons.mail),
                ),
              ],
            ),
          )
        ),
      );
  }
}