import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class BlogContent extends StatefulWidget {

  final String id;
  final String title;
  final String blogImagePath;
  final String userProfileImagePath;
  final String content;
  final String author;
  final String date;

  BlogContent({
    this.id,
    this.title,
    this.blogImagePath,
    this.userProfileImagePath,
    this.content,
    this.author,
    this.date,
  });

  @override
  _BlogContentState createState() => _BlogContentState();
}

class _BlogContentState extends State<BlogContent> {
  ZefyrController _zefyrController;

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
  }

  @override
  void dispose() {
    super.dispose();
    _zefyrController.dispose();
    _focusNode.dispose();
    _blogBloc.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final document = NotusDocument.fromDelta(Delta.fromJson(json.decode(widget.content) as List));
    _zefyrController = ZefyrController(document);
    _focusNode = FocusNode();

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Text(
                    this.widget.title,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            this.widget.author,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(top: 5.0),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              this.widget.date,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 300,
                            margin: EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                child: FutureBuilder<dynamic>(
                                    future: _blogBloc.getImageUrl(widget.id),
                                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                      if(snapshot.hasData) {
                                        return Container(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: snapshot.data.toString(),
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),);
                                      } else {
                                        return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),);
                                      }
                                    })
                              ),
                            ),
                          ),
                          Container(
                            height: 300,
                            margin: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xCC000000),
                                  const Color(0x00000000),
                                  const Color(0x00000000),
                                  const Color(0xCC000000),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            height: 60,
                            bottom: 15,
                            left: 15,
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(128),
                                  right: Radius.circular(128),
                                ),
                                child: Image.asset(
                                  'assets/images/user-image-placeholder.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 2.0, top: 10.0),
                        alignment: Alignment.topLeft,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child:
                        ZefyrScaffold(
                          child: ZefyrEditor(controller: _zefyrController, focusNode: _focusNode, enabled: false,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


























//import 'package:flutter/material.dart';
//
//class BlogScreenContent extends StatefulWidget {
//  @override
//  _BlogScreenContentState createState() => _BlogScreenContentState();
//}
//
//class _BlogScreenContentState extends State<BlogScreenContent> {
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        elevation: 0.0,
//        centerTitle: true,
//        backgroundColor: Colors.white,
//        leading: IconButton(
//          icon: Icon(Icons.close),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          color: Colors.grey,
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.message),
//            onPressed: () {},
//            color: Colors.grey,
//          ),
//        ],
//      ),
//      body: Stack(
//        children: <Widget>[
//          SafeArea(
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(right: 10.0, left: 10.0),
//                    child: Text(
//                      "Blog Title",
//                      style: TextStyle(
//                          fontSize: 28.0,
//                          fontWeight: FontWeight.bold,
//                          color: Colors.black54),
//                    ),
//                  ),
//
//                  Container(
//                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        Flexible(
//                          flex: 1,
//                          child: Container(
//                            alignment: Alignment.bottomLeft,
//                            margin: EdgeInsets.only(top: 5.0),
//                            child: Text(
//                              "Author name",
//                              style: TextStyle(
//                                  fontSize: 16.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.black45),
//                            ),
//                          ),
//                        ),
//                        Flexible(
//                          flex: 1,
//                          child: Container(
//                            alignment: Alignment.bottomRight,
//                            margin: EdgeInsets.only(top: 5.0),
//                            child: Container(
//                              alignment: Alignment.bottomRight,
//                              child: Text(
//                                "06/07/2019",
//                                style: TextStyle(
//                                    fontSize: 15.0,
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.black45),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  Stack(
//                    children: <Widget>[
//                      Container(
//                        height: 300,
//                        margin: EdgeInsets.all(3.0),
//                        child: ClipRRect(
//                          borderRadius: BorderRadius.all(Radius.circular(12)),
//                          child: Container(
//                            child: Image.asset(
//                              'assets/images/blog-image-placeholder.jpg',
//                              fit: BoxFit.cover,
//                            ),
//                          ),
//                        ),
//                      ),
//                      Container(
//                        height: 300,
//                        margin: EdgeInsets.all(3.0),
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(12)),
//                          gradient: LinearGradient(
//                            begin: Alignment.topCenter,
//                            end: Alignment.bottomCenter,
//                            colors: [
//                              const Color(0xCC000000),
//                              const Color(0x00000000),
//                              const Color(0x00000000),
//                              const Color(0xCC000000),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Positioned(
//                        height: 60,
//                        bottom: 15,
//                        left: 15,
//                        child: Container(
//                          child: ClipRRect(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.circular(128),
//                              right: Radius.circular(128),
//                            ),
//                            child: Image.asset(
//                              'assets/images/user-image-placeholder.jpg',
//                              fit: BoxFit.cover,
////                        alignment: Alignment(lerp(1, 0), 0),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Container(
//                    height: MediaQuery.of(context).size.height*0.4,
//                    alignment: Alignment.bottomLeft,
//                    margin: EdgeInsets.all(10.0),
//                    child: ListView(
//                      children: <Widget>[
//                        Text(
//                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Habitant morbi tristique senectus et netus. Leo a diam sollicitudin tempor id eu nisl. Turpis tincidunt id aliquet risus feugiat in ante. Urna duis convallis convallis tellus id interdum velit laoreet id. Erat velit usce ut. Amet nisl suscipit adipiscing bibendum est ultricies integer. Amet purus enenatis a condimentum vitae sapien pellentesque. Risus ultricies tristique nulla Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Habitant morbi tristique senectus et netus. Leo a diam sollicitudin tempor id eu nisl. Turpis tincidunt id aliquet risus feugiat in ante. Urna duis convallis convallis tellus id interdum velit laoreet id. Erat velit usce ut. Amet nisl suscipit adipiscing bibendum est ultricies integer. Amet purus enenatis a condimentum vitae sapien pellentesque. Risus ultricies tristique nulla Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Habitant morbi tristique senectus et netus. Leo a diam sollicitudin tempor id eu nisl. Turpis tincidunt id aliquet risus feugiat in ante. Urna duis convallis convallis tellus id interdum velit laoreet id. Erat velit usce ut. Amet nisl suscipit adipiscing bibendum est ultricies integer. Amet purus enenatis a condimentum vitae sapien pellentesque. Risus ultricies tristique nulla Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Habitant morbi tristique senectus et netus. Leo a diam sollicitudin tempor id eu nisl. Turpis tincidunt id aliquet risus feugiat in ante. Urna duis convallis convallis tellus id interdum velit laoreet id. Erat velit usce ut. Amet nisl suscipit adipiscing bibendum est ultricies integer. Amet purus enenatis a condimentum vitae sapien pellentesque. Risus ultricies tristique nulla Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Habitant morbi tristique senectus et netus. Leo a diam sollicitudin tempor id eu nisl. Turpis tincidunt id aliquet risus feugiat in ante. Urna duis convallis convallis tellus id interdum velit laoreet id. Erat velit usce ut. Amet nisl suscipit adipiscing bibendum est ultricies integer. Amet purus enenatis a condimentum vitae sapien pellentesque. Risus ultricies tristique nulla",
//                          style: TextStyle(
//                              fontSize: 16.0,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black45),
//                        ),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
