import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:practiceapp/services/auth/bloc/auth_event.dart';
import 'package:practiceapp/services/auth/bloc/auth_state.dart';
import 'package:practiceapp/utilities/dialogs/error_dialog.dart';
import '../services/auth/auth_exceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateRegistering){
          if(state.exception is WeakPasswordException){
            await showErrorDialog(context, 'Weak Password');
          }
          else if(state.exception is EmailAlreadyInUseException){
            await showErrorDialog(context, 'Email is already in use');
          }
          else if(state.exception is InvalidEmailException){
            await showErrorDialog(context, 'Invalid Email');
          }
          else{
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text('Register'))),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: "Enter Email Here..."),
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
                  context.read()<AuthBloc>().add(AuthEventRegisterUser(email, password));
        
                },
                child: const Text("Register"),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('Registered already? Log in here!')),
            ],
          ),
        ),
      ),
    );
  }
}
