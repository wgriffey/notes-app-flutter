import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:practiceapp/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter Email Here..."
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter Password Here...",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try{
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, 
                  password: password
                );
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
              }
              on FirebaseAuthException catch (e){
                switch (e.code){
                  case 'INVALID_LOGIN_CREDENTIALS':{
                    if (!context.mounted) return;
                    await showErrorDialog(context, 'Username or Password are incorrect');
                    break;
                  }
                  default:
                    if (!context.mounted) return;
                    await showErrorDialog(context, 'Error: ${e.code}');
                    break;
                }
              }
              catch (e){
                await showErrorDialog(
                  context,
                  'Unknown Error Occurred: ${e.toString()}');
              }
            },
            child: const Text("Log In"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            }, 
            child: const Text('Not registered yet? Register here!')
          ),
        ],
      ),
    );
  }
}