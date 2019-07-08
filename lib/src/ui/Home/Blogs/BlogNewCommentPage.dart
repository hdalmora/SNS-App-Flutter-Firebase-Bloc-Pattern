import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

final commentsScreenKey = new GlobalKey(debugLabel: 'CommentsScreen');

class BlogNewCommentPage extends StatefulWidget {
  final String blogUID;

  BlogNewCommentPage({
    @required this.blogUID,
  }) : super(key: commentsScreenKey);
  @override
  BlogNewCommentPageState createState() => BlogNewCommentPageState();
}

class BlogNewCommentPageState extends State<BlogNewCommentPage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  BlogBloc _blogBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogBloc = BlogBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    // Create an empty document or load existing if you have one.
    // Here we create an empty document:
    final document = new NotusDocument();
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  Delta getDelta(String doc) {
    return Delta.fromJson(json.decode(doc) as List);
  }

  @override
  void dispose() {
    _blogBloc.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
        cursorColor: Colors.blue,
        toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
          color: Colors.blue.shade800,
          toggleColor: Colors.blue.shade900,
          iconColor: Colors.white,
          disabledIconColor: Colors.blue.shade500,
        ));

    final post = [FlatButton(
        onPressed: () async {
          print("BLOG UID: ${widget.blogUID}");
          print("BLOG COMMENT: ${_blogBloc.comment.toString()}");
          _blogBloc.changeComment(json.encode(_controller.document));
          if(_blogBloc.validateComment()) {
            await _blogBloc.postComment(widget.blogUID);
            Navigator.of(context).pop();
          } else {
            print("COMMENT WRONG FORMAT");
          }
          _blogBloc.changeComment("");
        },
        child: Text('POST'))];

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.blue.shade200,
        brightness: Brightness.light,
        title: Text("new Comment"),
        actions: post,
      ),
      body: ZefyrScaffold(
        child: ZefyrTheme(
          data: theme,
          child: ZefyrEditor(
            controller: _controller,
            focusNode: _focusNode,
            enabled: true,
            imageDelegate: new CustomImageDelegate(),
          ),
        ),
      ),
    );
  }
}

/// Custom image delegate used by this example to load image from application
/// assets.
///
/// Default image delegate only supports [FileImage]s.
class CustomImageDelegate extends ZefyrDefaultImageDelegate {
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (imageSource.startsWith('asset://')) {
      final asset = new AssetImage(imageSource.replaceFirst('asset://', ''));
      return new Image(image: asset);
    } else {
      return super.buildImage(context, imageSource);
    }
  }
}
