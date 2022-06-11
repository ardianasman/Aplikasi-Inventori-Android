import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ambw/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obsecureText = true;
  bool _obsecureTextConfirm = true;

  void togglePassword() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void togglePasswordConfirm() {
    setState(() {
      _obsecureTextConfirm = !_obsecureTextConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                padding: const EdgeInsets.all(10),
                // ignore: prefer_const_constructors
                child: TextField(
                  //controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                // ignore: prefer_const_constructors
                child: TextField(
                  obscureText: _obsecureText,
                  //controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        togglePassword();
                      },
                      child: Icon(
                        _obsecureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: _obsecureTextConfirm,
                  //controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        togglePasswordConfirm();
                      },
                      child: Icon(
                        _obsecureText ? Icons.visibility : Icons.visibility_off,
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
                    //print(emailController.text);
                    //print(passwordController.text);
                    //signIn();
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => LoginPage()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )),
    );
  }
}
