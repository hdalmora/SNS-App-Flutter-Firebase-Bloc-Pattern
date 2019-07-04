import 'package:cloud_firestore/cloud_firestore.dart';

class BlogCommentModel {
  String id;
  String authorID;
  String authorName;
  String blogID;
  String authorEmail;
  String comment;
  Timestamp dateCreated;


  BlogCommentModel({this.id, this.authorID, this.authorName, this.blogID, this.authorEmail, this.comment, this.dateCreated});

  factory BlogCommentModel.fromDocument(DocumentSnapshot document) {

    return BlogCommentModel(

      id: document.documentID,

      authorID: document['userID'],

      authorName: document['userName'],

      blogID: document['blogID'],

      authorEmail: document['userEmail'],

      comment: document['comment'],

      dateCreated: document['dateCreated'] != null ? document['dateCreated'] : Timestamp(0, 0),
    );

  }
}