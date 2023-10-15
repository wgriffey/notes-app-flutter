import 'package:flutter/material.dart';
import 'package:practiceapp/services/auth/auth_service.dart';
import 'constants/routes.dart';
import 'views/login_view.dart';
import 'views/notes/new_notes_view.dart';
import 'views/notes/notes_view.dart';
import 'views/register_view.dart';
import 'views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const HomePage(),
        routes: {
          homeRoute: (context) => const HomePage(),
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          notesRoute: (context) => const NotesView(),
          newNotesRoute: (context) => NewNotesView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  devtools.log('You are a verified user!');
                } else {
                  devtools.log('You are not verified!');
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

              return const NotesView();
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            )
          ],
        );
      }).then((value) => value ?? false);
}
