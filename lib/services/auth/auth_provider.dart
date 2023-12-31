import 'auth_user.dart';

abstract interface class AuthProvider {
  Future<void> initializeApp();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password
  });
  Future<AuthUser> createUser({
    required String email,
    required String password
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}