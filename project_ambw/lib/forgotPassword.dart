import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
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
                  'Reset Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                // ignore: prefer_const_constructors
                child: TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    if (email!.isEmpty) {
                      return "Input email!";
                    } else if (!EmailValidator.validate(email)) {
                      return "Enter valid email!";
                    }

                    // email != null && !EmailValidator.validate(email)
                    //     ? "Enter valid email!"
                    //     : null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Reset Password'),
                  onPressed: () {
                    resetPassword();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      ),
    );

    try {
      print(emailController.text.trim());
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password Reset Email Sent')));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!.trim())));
    }
  }
}
