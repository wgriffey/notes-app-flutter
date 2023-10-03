import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
        ),
        builder:(context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return Column(
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
                        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, 
                          password: password
                        );
                        print(userCredential);
                      }
                      on FirebaseAuthException catch (e){
                        print(e.code);
                        switch (e.code){
                          case 'user-not-found': {
                            print('User Not Found'); 
                            break;
                          }
                          case 'wrong-password': {
                            print('Wrong Password'); 
                            break;
                          }
                          default:
                            print('Error with FirebaseAuth'); break;
                        }
                      }
                    },
                    child: const Text("Log In"),
                  ),
                ],
              );
            default:
              return const Text('Loading...');
          }
        }
      ),
    );
  }
}