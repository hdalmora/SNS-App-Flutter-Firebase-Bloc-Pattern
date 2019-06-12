import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  String id;
  String authorID;
  String authorEmail;
  String title;
  String content;
  Timestamp date;
  int likesCounter;


  BlogModel({this.id, this.authorID, this.authorEmail, this.title, this.content, this.date, this.likesCounter});

  factory BlogModel.fromDocument(DocumentSnapshot document) {

    return BlogModel(

      id: document.documentID,

      authorID: document['authorID'],

      authorEmail: document['authorEmail'],

      title: document['title'],

      content: document["content"],

      date: document['timestamp'] != null ? document['timestamp'] : Timestamp(0, 0),

      likesCounter: document['likesCounter'] != null ? document['likesCounter'] : 0,

    );

  }
}