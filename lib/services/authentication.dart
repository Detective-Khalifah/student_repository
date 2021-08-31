import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth;

  Authentication(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> logIn({required String email, required String pwd}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pwd);
      return "Logged in!";
    } on FirebaseAuthException catch (fae) {
      return fae.message;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> register({required String email, required String pwd}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      return "Registered!";
    } on FirebaseAuthException catch (fae) {
      return fae.message;
    }
  }
}
