import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String image;
  final String arrivalOfJapan;
  final String eMail;
  final String industry;
  final String about;
  final String nationality;
  final String role;
//  private List<LanguageModel> languages;
//  private List<UserRole> roles;

  UserModel({this.id, this.name, this.image, this.arrivalOfJapan, this.eMail,
      this.industry, this.about, this.nationality, this.role});

  factory UserModel.fromDocument(DocumentSnapshot document) {

    return UserModel(

      id: document.documentID,

      name: document['name'],

      image: document['imageURL'],

      arrivalOfJapan: document["arrivalOfJapan"],

      eMail: document['email'],

      industry: document['industry'],

      about: document['about'],

      nationality: document['nationality'],

      role: document['role'],

    );

  }
}