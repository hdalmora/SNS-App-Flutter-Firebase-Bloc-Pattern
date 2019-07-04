import 'package:flutter/material.dart';

class ZoomScaffold extends StatefulWidget {

  final Widget commentsScreen;
  final Screen contentScreen;

  ZoomScaffold({
    this.commentsScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold> with TickerProviderStateMixin {

  CommentsController commentsController;
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    commentsController = new CommentsController(
      vsync: this,
    )
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    commentsController.dispose();
    super.dispose();
  }

  createContentDisplay() {
    return zoomAndSlideContent(
        new Container(
          child: new Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "(13 comments)",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11.0
                  ),

                ),
              ),
              leading: IconButton(
                  icon: Icon(Icons.message),
                  color:Colors.blue,
                  onPressed: () {
                    commentsController.toggle();
                  }
              ),
              actions: <Widget>[
                IconButton(
                    icon: new Icon(Icons.close),
                    color: Colors.black38,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                widget.contentScreen.contentBuilder(context),
              ],
            ),
          ),
        )
    );
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;
    switch (commentsController.state) {
      case CommentsState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case CommentsState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case CommentsState.opening:
        slidePercent = slideOutCurve.transform(commentsController.percentOpen);
        scalePercent = scaleDownCurve.transform(commentsController.percentOpen);
        break;
      case CommentsState.closing:
        slidePercent = slideInCurve.transform(commentsController.percentOpen);
        scalePercent = scaleUpCurve.transform(commentsController.percentOpen);
        break;
    }

    final slideAmount = MediaQuery.of(context).size.width * 0.90 * slidePercent;
    final contentScale = 1 - (0.25 * scalePercent);
    final cornerRadius = 10.0 * commentsController.percentOpen;

    return new Transform(
      transform: new Matrix4
          .translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: const Color(0x44000000),
              offset: const Offset(0.0, 5.0),
              blurRadius: 20.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.commentsScreen,
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {

  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState extends State<ZoomScaffoldMenuController> {

  CommentsController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(
        new TypeMatcher<_ZoomScaffoldState>()
    ) as _ZoomScaffoldState;
    return scaffoldState.commentsController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }

}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context,
    CommentsController menuController
    );

class Screen {
  final String title;
  final DecorationImage blogImage;
  final DecorationImage userImage;
  final String content;
  final String author;
  final String date;
  final WidgetBuilder contentBuilder;

  Screen({
    this.title,
    this.blogImage,
    this.userImage,
    this.content,
    this.author,
    this.date,
    this.contentBuilder,
  });
}

class CommentsController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  CommentsState state = CommentsState.closed;

  CommentsController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = CommentsState.opening;
            break;
          case AnimationStatus.reverse:
            state = CommentsState.closing;
            break;
          case AnimationStatus.completed:
            state = CommentsState.open;
            break;
          case AnimationStatus.dismissed:
            state = CommentsState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == CommentsState.open) {
      close();
    } else if (state == CommentsState.closed) {
      open();
    }
  }
}

enum CommentsState {
  closed,
  opening,
  open,
  closing,
}