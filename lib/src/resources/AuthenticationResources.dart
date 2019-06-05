import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:async';
export 'package:firebase_auth/firebase_auth.dart';

class AuthenticationResources {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isUserAnonymous() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isAnonymous;
  }

  Future<String> getUserUID() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<String> getUserEmail() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  /// Authentication Methods
  /// ---------------------------------------------------------
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();

    } on PlatformException catch (e) {
      print("Platform Exception: Authentication Anonymous: " +
          e.toString());
      throw e;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      await _firebaseAuth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      print(
          "Platform Exception: Error communicating with the Google Platform: {$e}");
      throw e;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return 1;
    } on PlatformException catch (e) {
      print("Platform Exception: Authentication: " +
              e.toString());
      return -1;
    } catch (e) {
      print("Exception: Error: " + e.toString());
      return -2;
    }
  }

  Future<int> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 1;
    } on PlatformException catch (e) {
      print(
          "Platform Exception: Authentication: " +
              e.toString());
      return -1;
    } catch (e) {
      print("Exception: Authentication: " + e.toString());

      return -2;
    }
  }

  Future<void> get signOut => _firebaseAuth.signOut();

  Stream<FirebaseUser> get onAuthStateChange =>
      _firebaseAuth.onAuthStateChanged;
}
