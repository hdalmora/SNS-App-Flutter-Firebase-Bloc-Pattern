import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/Home/Blogs/BLogZoomScaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buddies_osaka/src/components/input-text-main.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:buddies_osaka/src/models/BlogCommentModel.dart';
import 'package:buddies_osaka/src/ui/Home/Blogs/BlogNewCommentPage.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:async';

final commentsScreenKey = new GlobalKey(debugLabel: 'CommentsScreen');

class CommentsScreen extends StatefulWidget {
  final QuerySnapshot commentsSnapshots;
  final Function(String) onCommentClicked;
  final String blogUID;

  CommentsScreen({
    this.commentsSnapshots,
    this.onCommentClicked,
    @required this.blogUID,
  }) : super(key: commentsScreenKey);

  @override
  _CommentsScreenState createState() => new _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen>
    with TickerProviderStateMixin {
  AnimationController titleAnimationController;
  double selectorYTop;
  double selectorYBottom;

  BlogBloc _blogBloc;

  ScrollController _controller;

  setSelectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      setState(() {
        selectorYTop = newYTop;
        selectorYBottom = newYBottom;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogBloc = BlogBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();



    _controller = ScrollController()..addListener(_scrollListener);
    titleAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Delta getDelta(String doc) {
    return Delta.fromJson(json.decode(doc) as List);
  }


  void _scrollListener() async {
//    print("SCROLL LISTENER:::");
//    if(_noMore) return;
//
//    if (_controller.position.pixels == _controller.position.maxScrollExtent && !_isFetchingLastDocs) {
//      setState(() {
//        _isFetchingLastDocs = true;
//      });
//
//      await _fetchBlogsDocumentsSnapshotFromLast();
//
//      setState(() {_isFetchingLastDocs = false;});
//    }
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    _blogBloc.dispose();
    if(_controller != null) {
      _controller.removeListener(_scrollListener);
    }
    super.dispose();
  }

  createMenuTitle(CommentsController commentsController) {
    switch (commentsController.state) {
      case CommentsState.open:
      case CommentsState.opening:
        titleAnimationController.forward();
        break;
      case CommentsState.closed:
      case CommentsState.closing:
        titleAnimationController.reverse();
        break;
    }

    return new AnimatedBuilder(
        animation: titleAnimationController,
        child: new OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topCenter,
          child: new Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              margin: EdgeInsets.only(top: 50.0),
              child: new Text(
                'Comments',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                ),
                textAlign: TextAlign.start,
                softWrap: false,
              ),
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return new Transform(
            transform: new Matrix4.translationValues(
              250.0 * (1.0 - titleAnimationController.value) - 100.0,
              0.0,
              0.0,
            ),
            child: child,
          );
        });
  }

  createMenuItems(CommentsController commentsController) {
    final List<Widget> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay =
    commentsController.state != CommentsState.closing ? 0.15 : 0.0;

    final animationIntervalStart = 1 * perListItemDelay;
    final animationIntervalEnd =
        animationIntervalStart + animationIntervalDuration;

    listItems.add(new AnimatedCommentListItem(
      commentsState: commentsController.state,
      duration: const Duration(milliseconds: 600),
      curve: new Interval(animationIntervalStart, animationIntervalEnd,
          curve: Curves.easeOut),
      commentsListItem: new _CommentsListItem(
        onTap: () {
          widget.onCommentClicked("Clicked");
          commentsController.close();
        },
      ),
    ));

    return new Transform(
      transform: new Matrix4.translationValues(
        0.0,
        120.0,
        0.0,
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 10,
            child: Column(
              children: listItems,
            ),
          ),
//          Flexible(
//            flex: 4,
//            child:
//            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ZoomScaffoldMenuController(
          builder: (BuildContext context, CommentsController commentsController) {
        if (commentsController.state == CommentsState.closed ||
            commentsController.state == CommentsState.closing ||
            selectorYTop == null) {}

        final animationIntervalDuration = 0.5;
        final perListItemDelay =
        commentsController.state != CommentsState.closing ? 0.15 : 0.0;

        final animationIntervalStart = 1 * perListItemDelay;
        final animationIntervalEnd =
            animationIntervalStart + animationIntervalDuration;

        return new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: new BoxDecoration(
            color: Color(0xFF204D9E),
          ),
          child: new Material(
            color: Colors.transparent,
            child: new Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: createMenuTitle(commentsController),
                    ),
                    Flexible(
                      flex: 11,
                      child: StreamBuilder(
                        stream: _blogBloc.commentsList(5, widget.blogUID),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {

                          if (snapshot.hasData) {
                            List<DocumentSnapshot> docs = snapshot.data.documents;
                            List<BlogCommentModel> commentsList = List<BlogCommentModel>();

                            docs.forEach((doc) {
                              commentsList.add(BlogCommentModel.fromDocument(doc));
                            });

                            if(commentsList.isNotEmpty) {
                              return ListView.builder(
                                controller: _controller,
                                scrollDirection: Axis.vertical,
                                itemCount: commentsList.length,
                                itemBuilder: (context, position) {
                                  DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                                      commentsList[position].dateCreated.microsecondsSinceEpoch);

                                  return AnimatedCommentListItem(
                                    commentsState: commentsController.state,
                                    duration: const Duration(milliseconds: 600),
                                    curve: new Interval(animationIntervalStart, animationIntervalEnd,
                                        curve: Curves.easeOut),
                                    commentsListItem: _CommentsListItem(
                                      name: commentsList[position].authorName,
                                      comment: commentsList[position].comment,
                                      date: date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString(),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child:
                                Text(
                                  "No comments for this blog", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                                ),

                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),

                    Flexible(
                      flex:2,
                      child: InkWell(
                        onTap: () {
                          Navigator.
                          push(
                              context,

                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>

                                      BlogNewCommentPage(blogUID: widget.blogUID,)));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.50,
                          margin: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(6.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Text("Post a new comment",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10.0),
                                      child: new IconButton(
                                        icon: new Icon(Icons.comment, color: Colors.blue,),
                                        onPressed: ()  {
                                        },
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AnimatedCommentListItem extends ImplicitlyAnimatedWidget {
  final _CommentsListItem commentsListItem;
  final CommentsState commentsState;
  final Duration duration;

  AnimatedCommentListItem({
    this.commentsListItem,
    this.commentsState,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedCommentListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.commentsState) {
      case CommentsState.closed:
      case CommentsState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case CommentsState.open:
      case CommentsState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: _opacity.evaluate(animation),
      child: new Transform(
        transform: new Matrix4.translationValues(
          0.0,
          _translation.evaluate(animation),
          0.0,
        ),
        child: widget.commentsListItem,
      ),
    );
  }
}

class _CommentsListItem extends StatefulWidget {
  final String name;
  final String comment;
  final String date;
  final Function() onTap;

  ZefyrController zefyrController;
  FocusNode focusNode;

  _CommentsListItem({
    this.name,
    this.comment,
    this.zefyrController,
    this.focusNode,
    this.date,
    this.onTap,
  });

  @override
  __CommentsListItemState createState() => __CommentsListItemState();
}

class __CommentsListItemState extends State<_CommentsListItem> {
  @override
  void dispose() {

    widget.zefyrController.dispose();
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final document = NotusDocument.fromDelta(Delta.fromJson(json.decode(widget.comment) as List));
    widget.zefyrController = ZefyrController(document);
    widget.focusNode = FocusNode();


    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.green,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'))),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:EdgeInsets.only(top: 5.0, left: 15.0, bottom: 2.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 15.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.date,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black26,
                              fontSize: 11.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(left: 2.0, top: 10.0),
                  alignment: Alignment.topLeft,
                  height: 100,
                  child:
                  ZefyrScaffold(
                    child: ZefyrEditor(controller: widget.zefyrController, focusNode: widget.focusNode, enabled: false,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
