import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buddies_osaka/src/models/BlogModel.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> createUserProfile(String userID, String email, String name, String about, String arrivalOfJapan, String nationality, Map<String, String> languages, String industry) async
    => _firestore
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


  Future<void> postBlog(String userUID, String userEmail, String title, String content) async => _firestore
        .collection("blogs")
        .document()
        .setData(({
          'authorID': userUID,
          'authorEmail': userEmail,
          'title': title,
          'content': content,
          'likesCounter': 0,
          'timestamp': FieldValue.serverTimestamp()
        }));


  Future<void> likeBlogPost(String blogUID, String userUID) async => _firestore
      .collection("blogLikes")
      .document('$blogUID:$userUID')
      .setData({});

  Future<void> unlikeBlogPost(String blogUID, String userUID) async => _firestore
      .collection("blogLikes")
      .document('$blogUID:$userUID')
      .delete();

  Future<bool> hasLikedBlog(String blogUID, String userUID) async {
    final like = await _firestore
        .collection('blogLikes')
        .document('$blogUID:$userUID')
        .get();
    return like.exists;
  }

  Stream<QuerySnapshot> blogsList(int limit) => _firestore
      .collection("blogs")
      .limit(limit)
      .orderBy('timestamp', descending: true)
      .snapshots();

  Stream<DocumentSnapshot> getUserData(String documentId) => _firestore.collection("users").document(documentId).snapshots();

}