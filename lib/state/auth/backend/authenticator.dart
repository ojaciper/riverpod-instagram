import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instantgram_clone/state/auth/constants/constants.dart';
import 'package:instantgram_clone/state/auth/models/auth_result.dart';
import 'package:instantgram_clone/state/posts/typedefs/user_id.dart';

class Authenticator {
  const Authenticator();
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? "";

  String? get email => FirebaseAuth.instance.currentUser?.email;

  /// login out function
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  // facebook login
  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.tokenString;

    try {
      if (token == null) {
        // user has aborted the loggin process
        return AuthResult.aborted;
      }
      // user contune with loggin process
      final oauthCredential = FacebookAuthProvider.credential(token);
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return AuthResult.success;
    } on FirebaseAuthException catch (error) {
      final email = error.email;
      final credential = error.credential;
      if (error.code == Constants.accountExistsWithDifferentCredential &&
          email != null &&
          credential != null) {
        // checking if a user already exist with them same email
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        // final provider =
        //     await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (query.docs.isNotEmpty) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }
    final googleAuth = await signInAccount.authentication;
    final authCredentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(authCredentials);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
