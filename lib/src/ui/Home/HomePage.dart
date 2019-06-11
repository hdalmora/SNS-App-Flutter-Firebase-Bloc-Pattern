import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/models/UserModel.dart';
import 'package:buddies_osaka/src/blocs/user/UserBlocProvider.dart';
import 'package:buddies_osaka/src/blocs/user/UserBloc.dart';
import 'package:buddies_osaka/src/ui/Home/Blogs/Blogs.dart';
import 'package:buddies_osaka/src/ui/Home/Questions/Questions.dart';
import 'package:buddies_osaka/src/ui/Home/Events/Events.dart';
import 'package:buddies_osaka/src/ui/AddToCommunity/AddToCommunityPage.dart';
import 'package:buddies_osaka/src/ui/widgets/user_profile_bottom_sheet.dart';
import 'package:buddies_osaka/src/ui/widgets/upper_tabs.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buddies_osaka/src/ui/CreateProfilePage.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBloc.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBlocProvider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;
  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 50);

  UserBloc _userBloc;
  UserModel _user;

  AuthenticationBloc _authBloc;

  bool _blogsSelected = true;
  bool _eventsSelected = false;
  bool _qAndASelected = false;

  PageController _pageController;
  int _page = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = UserBlocProvider.of(context);
    _authBloc = AuthenticationBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    _authBloc.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void selectTabBar(String tab) {
    switch (tab) {
      case "blog":
        setState(() {
          _blogsSelected = true;
          _eventsSelected = false;
          _qAndASelected = false;
        });
        navigationTapped(0);
        break;
      case "events":
        setState(() {
          _eventsSelected = true;
          _blogsSelected = false;
          _qAndASelected = false;
        });
        navigationTapped(1);
        break;
      case "QA":
        setState(() {
          _qAndASelected = true;
          _blogsSelected = false;
          _eventsSelected = false;
        });
        navigationTapped(2);
        break;
      default:
        setState(() {
          _blogsSelected = true;
          _eventsSelected = false;
          _qAndASelected = false;
        });
        navigationTapped(0);
    }
  }

  void _onTapFAB() {
    setState(() => rect = RectGetter.getRectFromKey(
        rectGetterKey));

    WidgetsBinding.instance.addPostFrameCallback((_) {

      setState(() => rect = rect.inflate(1.3 *
          MediaQuery.of(context).size.longestSide));

      Future.delayed(animationDuration + delay,
          _goToNextPage);
    });
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: AddToCommunityPage()))
        .then((_) => setState(() => rect = null));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white, //Color(0xFF204D9E),
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Color(0xFFFF),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                color: Colors.grey,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                  color: Colors.grey,
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 25.0),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15.0),
                                child: Text(
                                  'teste@email.com',
                                  style: TextStyle(
                                      color: Color(0xFF204D9E),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.insert_emoticon),
                    title: Text("Community"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.call_received),
                    title: Text("Sign Out"),
                    onTap: () async {
                      _authBloc.signOut();
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: UpperTab(
                                callback: () {
                                  selectTabBar("blogs");
                                },
                                text: 'Blogs',
                                isSelected: _blogsSelected),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: UpperTab(
                                callback: () {
                                  selectTabBar("events");
                                },
                                text: 'Events',
                                isSelected: _eventsSelected),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: UpperTab(
                                callback: () {
                                  selectTabBar("QA");
                                },
                                text: 'Q&A\'s',
                                isSelected: _qAndASelected),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [Blogs(), Events(), Questions()],
                        onPageChanged: onPageChanged,
                        controller: _pageController,
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: _userBloc.isAnonym(),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      /// ANONYM USER ---------------------------------
                      ///
                      ///
                      return Positioned(
                        height: 140,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          decoration: const BoxDecoration(
                            color: Color(0xFF162A49),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Hey !',
                                    style: TextStyle(
                                        fontFamily:
                                        'Montserrat',
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 30.0,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'You are logged in as an Anonymous user. To access all our community contents, please',
                                    style: TextStyle(
                                        fontFamily:
                                        'Montserrat',
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Align(
                                    alignment:
                                    Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
//                                        Route route =
//                                        MaterialPageRoute(
//                                            builder:
//                                                (context) =>
//                                                CreateProfilePage(
//                                                  userUID:
//                                                  userDocId.data,
//                                                ));
//
//                                        Navigator.push(
//                                            context, route);
                                      },
                                      child: Text(
                                        'UPGRADE ACCOUNT',
                                        style: TextStyle(
                                            fontFamily:
                                            'Montserrat',
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return FutureBuilder(
                        future: _userBloc.getUserUID(),
                        builder: (context, AsyncSnapshot<String> userDocId) {
                          if (userDocId.hasData && userDocId.data.length > 0) {
                            return StreamBuilder<DocumentSnapshot>(
                              stream: _userBloc.getUserData(userDocId.data),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  if (!snapshot.data.exists) {
                                    /// MEMBER USER ---------------------------------
                                    /// PROFILE NOT YET CREATED
                                    ///
                                    return Positioned(
                                      height: 140,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF162A49),
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(32)),
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Hello!',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30.0,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    'First, lets create your profile in our community',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 15.0,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CreateProfilePage(
                                                                          userUID:
                                                                              userDocId.data,
                                                                        ));

                                                        Navigator.push(
                                                            context, route);
                                                      },
                                                      child: Text(
                                                        'CREATE PROFILE',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.0,
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    /// MEMBER USER ---------------------------------
                                    /// PROFILE ALREADY CREATED
                                    ///
                                    _user = UserModel.fromDocument(snapshot.data);
                                    return Container(
                                        child: Stack(
                                          children: <Widget>[
                                            UserProfileBottomSheet(name:_user.name, industry:_user.industry, nationality:_user.nationality, about: _user.about,),
                                            Container(
                                              margin: EdgeInsets.all(15.0),
                                              child: Align(
                                                alignment: Alignment.bottomRight,
                                                child: RectGetter(
                                                  key: rectGetterKey,
                                                  child: Container(
                                                    margin: EdgeInsets.only(bottom: 0.0),
                                                    child: FloatingActionButton(
                                                      onPressed: _onTapFAB,
                                                      child: Icon(Icons.add),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                  }
                                } else {
                                  return Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFF3498db),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            return Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 15.0),
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xFF3498db),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            )),
        _ripple(),
      ],
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }

    return AnimatedPositioned(
      //<--replace Positioned with AnimatedPositioned
      duration: animationDuration, //<--specify the animation duration
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

/// -------------------- INNER CLASSES AND WIDGETS ---------------------- ///
///
///
///

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}
