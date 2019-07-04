import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> createUserProfile(String userID, String email, String name, String about, DateTime arrivalOfJapan, String nationality, Map<String, String> languages, String industry) async
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

  Future<void> postUserCommentToBlog(String userUID, String blogUID, String userEmail, String userName, String comment) async =>
    _firestore.collection("blogs")
      .document(blogUID)
      .collection("comments")
      .document()
      .setData(({
        'userID': userUID,
        'blogID': blogUID,
        'userEmail': userEmail,
        'userName': userName,
        'comment': comment,
        'dateCreated': FieldValue.serverTimestamp()
      }));

  Stream<QuerySnapshot> blogCommentsList(int limit, String blogUID) => _firestore
      .collection("blogs")
      .document(blogUID)
      .collection("comments")
      .orderBy("dateCreated", descending: true)
      .snapshots();

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

  Future<QuerySnapshot> fetchBlogs(int limit) => _firestore
      .collection("blogs")
      .limit(limit)
      .orderBy('timestamp', descending: true)
      .getDocuments();

  Future<QuerySnapshot> fetchBlogsFromLastDocument(int limit, DocumentSnapshot lastDoc) => _firestore
      .collection("blogs")
      .limit(limit)
      .orderBy('timestamp', descending: true)
      .startAfter([lastDoc['timestamp']])
      .getDocuments();

  Stream<DocumentSnapshot> getUserData(String documentId) => _firestore.collection("users").document(documentId).snapshots();

}