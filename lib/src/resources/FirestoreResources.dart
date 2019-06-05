import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> createUserProfile(String userID, String email, String name, String about, String arrivalOfJapan, String nationality, Map<String, String> languages, String industry) async {
    return _firestore
        .collection("users")
        .document(userID)
        .setData({
          'id': userID,
          'email': email,
          'name': name,
          'about': about,
          'arrivalOfJapan': arrivalOfJapan,
          'nationality': nationality,
          'languages': languages,
          'industry': industry,
          'role': "Registered User",
        });
  }

  Stream<DocumentSnapshot> getUserData(String documentId) {
    return _firestore.collection("users").document(documentId).snapshots();
  }
}