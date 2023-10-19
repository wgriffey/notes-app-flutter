import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:practiceapp/services/auth/bloc/auth_event.dart';
import 'package:practiceapp/services/auth/bloc/auth_state.dart';
import 'package:practiceapp/services/auth/firebase_auth_provider.dart';
import 'constants/routes.dart';
import 'views/login_view.dart';
import 'views/notes/create_update_note_view.dart';
import 'views/notes/notes_view.dart';
import 'views/register_view.dart';
import 'views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(FirebaseAuthProvider()),
            child: const HomePage()),
        routes: {
          homeRoute: (context) => const HomePage(),
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          notesRoute: (context) => const NotesView(),
          createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
