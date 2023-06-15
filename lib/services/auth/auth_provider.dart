import 'package:bluecheck/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<void> get reloadUser;
  

  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> loginWithGoogle();
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
