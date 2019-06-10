import 'package:cloud_firestore/cloud_firestore.dart';
import 'FirestoreResources.dart';
import 'AuthenticationResources.dart';
import 'dart:async';

class Repository {
  final _firestoreResources = FirestoreProvider();
  final _authResources = AuthenticationResources();

  Future<String> getUserUID() => _authResources.getUserUID();

  Future<String> getUserEmail() => _authResources.getUserEmail();

  Future<bool> isUserAnonymous() => _authResources.isUserAnonymous();

  Future<void> createUserProfile(String userID, String email, String name, String about, String arrivalOfJapan, String nationality, Map<String, String> languages, String industry) =>
      _firestoreResources.createUserProfile(userID, email, name, about, arrivalOfJapan, nationality, languages, industry);

  Stream<DocumentSnapshot> getUserData(String documentID) => _firestoreResources.getUserData(documentID);

  Future<void> signInAnonymously() => _authResources.signInAnonymously();


  Future<int> signInWithEmailAndPassword(String email, String password) => _authResources.signInWithEmailAndPassword(email, password);


  Future<int> signUpWithEmailAndPassword(String email, String password) => _authResources.signUpWithEmailAndPassword(email, password);


  Future<void> signOut() => _authResources.signOut;


}
