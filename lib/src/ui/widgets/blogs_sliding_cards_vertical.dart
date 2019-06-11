import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buddies_osaka/src/models/BlogModel.dart';
import 'dart:async';

class BlogsVerticalSlidingCardsView extends StatefulWidget {
  @override
  _BlogsVerticalSlidingCardsViewState createState() => _BlogsVerticalSlidingCardsViewState();
}

class _BlogsVerticalSlidingCardsViewState extends State<BlogsVerticalSlidingCardsView> {
  BlogBloc _blogBloc;

  List<BlogModel> _blogsList;

  DocumentSnapshot _lastDocument;
  ScrollController _controller;

  bool _noMore = false;
  var _isFetchingLastDocs = false;
  var _isFetchingFirstDocs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogBloc = BlogBlocProvider.of(context);
    _fetchBlogsDocumentsSnapshot();

  }

  @override
  void initState() {
    _controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _blogBloc.dispose();
    if(_controller != null) {
      _controller.removeListener(_scrollListener);
    }
    super.dispose();
  }

  Future<Null> _fetchBlogsDocumentsSnapshot() async {
    setState(() {
      _isFetchingFirstDocs = true;
    });

    final QuerySnapshot querySnapshot = await _blogBloc.fetchBlogs(4);

    _lastDocument = querySnapshot.documents.last;

    List<DocumentSnapshot> blogsSnapshots = querySnapshot.documents;
    _blogsList = List<BlogModel>();

    blogsSnapshots.forEach((doc) {
      _blogsList.add(BlogModel.fromDocument(doc));
    });

    setState(() {_isFetchingFirstDocs = false;});
    print("BLOGS SIZE: " + _blogsList.length.toString());
  }

  Future<Null> _fetchBlogsDocumentsSnapshotFromLast() async {
    final QuerySnapshot querySnapshot = await _blogBloc.fetchBlogsFromLastDocument(4, _lastDocument);

    print("LAST SNAPSHOTS SIZE: " + querySnapshot.documents.length.toString());

    if (querySnapshot.documents.length < 4) {
      setState(() {
        _noMore = true;
      });
    }

    _lastDocument = querySnapshot.documents.last;

    List<DocumentSnapshot> lastBlogsSnapshots = querySnapshot.documents;

    lastBlogsSnapshots.forEach((doc) {
      _blogsList.add(BlogModel.fromDocument(doc));
    });
    print("BLOG AFTER LIST SIZE: " + _blogsList.length.toString());
    setState(() {});
  }


    void _scrollListener() async {
    print("SCROLL LISTENER:::");
    if(_noMore) return;

    if (_controller.position.pixels == _controller.position.maxScrollExtent && !_isFetchingLastDocs) {
      setState(() {
        _isFetchingLastDocs = true;
      });

      await _fetchBlogsDocumentsSnapshotFromLast();

      setState(() {_isFetchingLastDocs = false;});
    }
  }

  void _likeBlog(String blogUID) async {
    if(await _blogBloc.hasLikedBlog(blogUID)) {
      _blogBloc.unlikeBlogPost(blogUID);
    } else {
      _blogBloc.likeBlogPost(blogUID);
    }
  }

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();
    _noMore = false;
    _blogsList.clear();
    await _fetchBlogsDocumentsSnapshot();
    completer.complete();
    return completer.future;
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: <Widget>[
            _isFetchingFirstDocs == false ?
              _blogsList.length > 0 ? RefreshIndicator(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _controller,
                        itemCount: _blogsList.length,
                        itemBuilder: (context, position) {
                          DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                              _blogsList[position].date.microsecondsSinceEpoch);

                          return SlidingCard(
                            title: _blogsList[position].title,
                            content: _blogsList[position].content,
                            author: _blogsList[position].authorEmail,
                            date: date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString(),
                            likes: _blogsList[position].likesCounter.toString(),
                            alreadyLiked: _blogBloc.hasLikedBlog(_blogsList[position].id),
                            callback: () {},
                            onLikePressed: () async {
                              _likeBlog(_blogsList[position].id);
                            },
                          );
                        },
                    ),
                    onRefresh: _handleRefresh
                ) : Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 35.0, left: 15.0, right: 15.0, bottom: 20.0),
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        "Não existem projetos registrados em sua escola.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0
                        ),
                      ),
                    ),
                    Icon(
                      Icons.mood_bad,
                      size: 40.0,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ) : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor:  Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white
                  ),
                ),
              ),
            SizedBox(height: 5.0,),
            Align(
              alignment: Alignment.bottomCenter,
              child: _isFetchingLastDocs ? LinearProgressIndicator(
                backgroundColor: Colors.blue,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white
                ),
              ) : SizedBox(height: 1.0,),
            ),
          ],
        ),
      ),
    );




//      Center(
//      child: Container(
//        width: MediaQuery.of(context).size.width * 0.9,
//        child: StreamBuilder(
//            stream: _isLoadingLastDocs ? null :  _blogBloc.blogsList(4),
//            builder:
//                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//              if (snapshot.hasData) {
//
//                List<DocumentSnapshot> blogsSnapshots = snapshot.data.documents;
//                _blogsList = List<BlogModel>();
//
//                blogsSnapshots.forEach((doc) {
//                  _blogsList.add(BlogModel.fromDocument(doc));
//                });
//
//                print("BLOG BEFORE LIST SIZE: " + _blogsList.length.toString());
//
//                if (_blogsList.isNotEmpty) {
//                  _lastDocument = blogsSnapshots.last;
//
//                  return ListView.builder(
//                        scrollDirection: Axis.vertical,
//
//                        controller: _controller,
//                        itemCount: _blogsList.length,
//                        itemBuilder: (context, position) {
//                          DateTime date = DateTime.fromMicrosecondsSinceEpoch(
//                              _blogsList[position].date.microsecondsSinceEpoch);
//
//
//                          return SlidingCard(
//                            title: _blogsList[position].title,
//                            content: _blogsList[position].content,
//                            author: _blogsList[position].authorEmail,
//                            date: date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString(),
//                            likes: _blogsList[position].likesCounter.toString(),
//                            alreadyLiked: _blogBloc.hasLikedBlog(_blogsList[position].id),
//                            callback: () {},
//                            onLikePressed: () async {
//                              _likeBlog(_blogsList[position].id);
//                            },
//                          );
//                        },
//                      );
//                } else {
//                  return Text("No Blogs created");
//                }
//              } else {
//                return Container(
//                  alignment: Alignment.topCenter,
//                  margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
//                  child: CircularProgressIndicator(
//                    backgroundColor: Color(0xFF3498db),
//                  ),
//                );
//              }
//            }),
//      ),
//    );
  }
}

class SlidingCard extends StatelessWidget {
  final String title;

  final String content;

  final String author;

  final String date;

  final String likes;

  final Future<dynamic> alreadyLiked;

  final VoidCallback callback;

  final VoidCallback onLikePressed;

  const SlidingCard({
    Key key,
    @required this.title,
    @required this.content,
    @required this.author,
    @required this.date,
    @required this.likes,
    @required this.alreadyLiked,
    @required this.callback,
    @required this.onLikePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: InkWell(
          onTap: callback,
          child: Card(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
            elevation: 8,

            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8),
                Expanded(
                  child: CardContent(
                    title: title,
                    content: content,
                    author: author,
                    date: date,
                    alreadyLiked: alreadyLiked,
                    likes: likes,
                    onLikePressed: onLikePressed,
                  ),
                ),
              ],
            ),
          ),
        ),
    );

  }
}

class CardContent extends StatelessWidget {
  final String title;

  final String content;

  final String author;

  final String date;

  final Future<dynamic> alreadyLiked;

  final String likes;

  final VoidCallback onLikePressed;

  const CardContent(
      {Key key,
        @required this.title,
        @required this.content,
        @required this.author,
        @required this.date,
        @required this.alreadyLiked,
        @required this.likes,
        @required this.onLikePressed,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),

          SizedBox(height: 8),
          Text(
              content,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),

          SizedBox(height: 8),
          Text(
              author,
              style:
              TextStyle(color: Colors.black26, fontWeight: FontWeight.bold),
            ),

          SizedBox(height: 2),
          Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),

          Spacer(),
          Row(
            children: <Widget>[
              Row(
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                        future: alreadyLiked,
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {

                          return IconButton(
                            color: snapshot.data == true ? Colors.yellow : Colors.black26,
                            icon: Icon(Icons.star),
                            onPressed: onLikePressed,
                          );

                        }
                    ),
                    Text(
                      likes,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black54),
                    ),
                  ],
                ),

              Spacer(),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
