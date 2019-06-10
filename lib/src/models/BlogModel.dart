import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String authorID;
  final String authorEmail;
  final String title;
  final String content;
  final Timestamp date;


  BlogModel({this.id, this.authorID, this.authorEmail, this.title, this.content, this.date});

  factory BlogModel.fromDocument(DocumentSnapshot document) {

    return BlogModel(

      id: document.documentID,

      authorID: document['authorID'],

      authorEmail: document['authorEmail'],

      title: document['title'],

      content: document["content"],

      date: document['timestamp'],

    );

  }
}