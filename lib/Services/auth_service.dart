import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name.trim());
    await cred.user?.reload();
    return _auth.currentUser;
  }

  Future<User?> login({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return cred.user;
  }

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> logout() => _auth.signOut();

  /// Firebase error code -> user friendly message
  static String errorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ye email pehle se registered hai. Login karein.';
      case 'invalid-email':
        return 'Email sahi format mein nahi hai.';
      case 'weak-password':
        return 'Password kam az kam 6 characters ka hona chahiye.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ya password ghalat hai.';
      case 'user-disabled':
        return 'Ye account disable kar diya gaya hai.';
      case 'too-many-requests':
        return 'Bohat zyada koshishein. Thori dair baad try karein.';
      case 'network-request-failed':
        return 'Internet connection check karein.';
      default:
        return e.message ?? 'Kuch ghalat ho gaya. Dobara try karein.';
    }
  }
}
