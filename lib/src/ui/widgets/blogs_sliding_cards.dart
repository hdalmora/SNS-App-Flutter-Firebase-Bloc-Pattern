import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buddies_osaka/src/models/BlogModel.dart';
import 'dart:async';

class BlogsSlidingCardsView extends StatefulWidget {
  @override
  _BlogsSlidingCardsViewState createState() => _BlogsSlidingCardsViewState();
}

class _BlogsSlidingCardsViewState extends State<BlogsSlidingCardsView> {
  PageController pageController;

  double pageOffset = 0;

  BlogBloc _blogBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogBloc = BlogBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    _blogBloc.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _likeBlog(String blogUID) async {
    if(await _blogBloc.hasLikedBlog(blogUID)) {
      _blogBloc.unlikeBlogPost(blogUID);
    } else {
      _blogBloc.likeBlogPost(blogUID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: StreamBuilder(
          stream: _blogBloc.blogsList(5),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.documents;
              List<BlogModel> blogsList = List<BlogModel>();

              docs.forEach((doc) {
                blogsList.add(BlogModel.fromDocument(doc));
              });

              if (blogsList.isNotEmpty) {
                return Stack(
                  children: <Widget>[
                    PageView.builder(
                      controller: pageController,
                      itemCount: blogsList.length,
                      itemBuilder: (context, position) {
                        DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                            blogsList[position].date.microsecondsSinceEpoch);
                        return SlidingCard(
                          title: blogsList[position].title,
                          content: blogsList[position].content,
                          author: blogsList[position].authorEmail,
                          date: date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString(),
                          likes: blogsList[position].likesCounter.toString(),
                          offset: pageOffset - position,
                          alreadyLiked: _blogBloc.hasLikedBlog(blogsList[position].id),
                          callback: () {},
                          onLikePressed: () async {
                            _likeBlog(blogsList[position].id);
                          },
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15.0, top: MediaQuery.of(context).size.height * 0.275,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "View All >",
                            style: TextStyle(
                              fontSize: 16,

                              color: Colors.black45, //: Colors.grey,

                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Text("No Blogs created");
              }
            } else {
              return Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFF3498db),
                ),
              );
            }
          }),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String title;

  final String content;

  final String author;

  final String date;

  final String likes;

  final double offset;

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
    @required this.offset,
    @required this.alreadyLiked,
    @required this.callback,
    @required this.onLikePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
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
                  offset: gauss,
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

  final double offset;

  const CardContent(
      {Key key,
      @required this.title,
      @required this.content,
      @required this.author,
      @required this.date,
      @required this.alreadyLiked,
      @required this.likes,
      @required this.onLikePressed,
      @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(
              content,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              author,
              style:
                  TextStyle(color: Colors.black26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 2),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: Row(
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
