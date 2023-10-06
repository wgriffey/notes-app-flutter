import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:practiceapp/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, 
                  password: password
                );                
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
              }
              on FirebaseAuthException catch (e){
                switch(e.code){
                  case 'email-already-in-use': {
                    devtools.log('Email is already in use');
                    break;
                  }
                  case 'weak-password': {
                    devtools.log('Weak Password');
                    break;
                  }
                  case 'invalid-email': {
                    devtools.log('Invalid Email');
                    break;
                  }
                  default: {
                    devtools.log('Error with FirebaseAuth');
                    break;
                  }
                }
              }
    
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            }, 
            child: const Text('Registered already? Log in here!')
          ),
        ],
      ),
    );
  }
}