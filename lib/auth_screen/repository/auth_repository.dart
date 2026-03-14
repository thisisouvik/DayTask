import 'package:daytask/auth_screen/models/auth_models.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;
  final _googleauth = GoogleSignIn.instance;
  bool _isGoogleInitialized = false;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session == null) {
      throw Exception('Sign-in failed, Retry after some time');
    }
  }

  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_Name': fullName},
    );
  }

  Future<void> signInWithGoogle() async {
    if (!_isGoogleInitialized) {
      await _googleauth.initialize();
      _isGoogleInitialized = true;
    }

    final googleUser = await _googleauth.authenticate();

    final googleAuth = googleUser.authentication;

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
    );

    if (response.session == null) {
      throw Exception('Sign-in failed, Retry after some time');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleauth.signOut();
  }

  AuthModels? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return AuthModels.fromSupabaseUser(user.toJson());
  }
}
