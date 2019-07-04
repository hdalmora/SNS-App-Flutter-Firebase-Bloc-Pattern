import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/Home/Blogs/BlogCommentsScreen.dart';
import 'package:buddies_osaka/src/ui/Home/Blogs/BlogScreenContent.dart';
import 'package:buddies_osaka/src/ui/Home/Blogs/BLogZoomScaffold.dart';

class BLogPage extends StatefulWidget {

  String title;
  String author;
  String dateCreated;
  String content;
  String blogUID;

  BLogPage({Key key, this.blogUID, this.title, this.author, this.dateCreated, this.content});

  @override
  _BLogPageState createState() => new _BLogPageState(blogUID: blogUID, title: title, author: author, dateCreated: dateCreated, content: content);
}

class _BLogPageState extends State<BLogPage> {

  String title;
  String author;
  String dateCreated;
  String content;
  String blogUID;

  _BLogPageState({Key key, this.blogUID, this.title, this.author, this.dateCreated, this.content});

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    print("TITLE: ${this.title}");

    final Screen blogScreen = new Screen(
        contentBuilder: (BuildContext context) {
          return BlogContent(title: this.title, author: this.author, content: this.content, date: this.dateCreated,);
        }
    );

    return new ZoomScaffold(
      commentsScreen: new CommentsScreen(blogUID: this.blogUID,),
      contentScreen: blogScreen,
    );
  }
}