import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String authorID;
  final String authorEmail;
  final String title;
  final String content;
  final Timestamp date;
  final int likesCounter;


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