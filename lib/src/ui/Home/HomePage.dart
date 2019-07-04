import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/models/UserModel.dart';
import 'package:buddies_osaka/src/blocs/user/UserBlocProvider.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
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
import 'package:buddies_osaka/src/ui/MembersPage.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBloc.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBlocProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buddies_osaka/src/components/input-text-main.dart';
import 'package:buddies_osaka/src/components/button-main-text-icon.dart';

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
  BlogBloc _blogBloc;
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
    _blogBloc = BlogBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

  }

  @override
  void dispose() {
    _userBloc.dispose();
    _blogBloc.dispose();
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

  void showErrorMessage(String message) {
    final snackbar =
        SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
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
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
          rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));

      Future.delayed(animationDuration + delay, _goToNextPage);
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
                  icon: Icon(Icons.face),
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
                                  child: StreamBuilder<FirebaseUser>(
                                      stream: _authBloc.onUserAuthChange(),
                                      builder: (contenxt,
                                          AsyncSnapshot<FirebaseUser>
                                              userSnapshot) {
                                        if (userSnapshot.hasData) {
                                          if (userSnapshot.data.providerData[0].displayName != null) {
                                            return Text(
                                              userSnapshot.data.providerData[0].displayName,
                                              style: TextStyle(
                                                  color: Color(0xFF204D9E),
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.0),
                                            );
                                          } else {
                                            return Text(
                                              "Guest user",
                                              style: TextStyle(
                                                  color: Color(0xFF204D9E),
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.0),
                                            );
                                          }
                                        }
                                      })),
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
                    leading: Icon(Icons.group),
                    title: Text("Members"),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MembersPage()));
                    },
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
                    StreamBuilder(
                      stream: _blogBloc.userHasPermission,
                      builder: (context, created) {
                        if(created.hasData) {
                          print("Created data: ${created.data.toString()}");
                          return Flexible(
                            flex: 10,
                            child: PageView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [Blogs(createdProfile: created.data,), Events(), Questions()],
                              onPageChanged: onPageChanged,
                              controller: _pageController,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
                StreamBuilder<FirebaseUser>(
                  stream: _authBloc.onUserAuthChange(),
                  builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
                    if (userSnapshot.hasData) {
                      if (userSnapshot.data.isAnonymous) {
                        // ANONYM USER -- SHOW ANONYM SHEET

                        _blogBloc.setUserPermission(false);

                        return Positioned(
                          height: 160,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: const BoxDecoration(
                              color: Color(0xFF162A49),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(32)),
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
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'You are logged in as an Guest. To access all our community contents, please',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext contextc) {
                                                return AlertDialog(
                                                  title:
                                                      Text("Upgrade Account"),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'Be a part of our community!',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black45),
                                                      ),
                                                      SizedBox(
                                                        height: 25.0,
                                                      ),
                                                      StreamBuilder(
                                                          stream: _authBloc
                                                              .displayName,
                                                          builder: (context,
                                                              snapshot) {
                                                            return InputTextMain(
                                                              fillColor: Color(
                                                                      0xD3D3D3)
                                                                  .withAlpha(
                                                                      50),
                                                              hintText:
                                                                  "Nickname...",
                                                              errorText:
                                                                  snapshot
                                                                      .error,
                                                              onChanged: _authBloc
                                                                  .changeDisplayName,
                                                              textType:
                                                                  TextInputType
                                                                      .text,
                                                              height: 60.0,
                                                            );
                                                          }),
                                                      StreamBuilder(
                                                          stream:
                                                              _authBloc.email,
                                                          builder: (contextc,
                                                              snapshot) {
                                                            return InputTextMain(
                                                              fillColor: Color(
                                                                      0xD3D3D3)
                                                                  .withAlpha(
                                                                      50),
                                                              hintText:
                                                                  "Email...",
                                                              errorText:
                                                                  snapshot
                                                                      .error,
                                                              onChanged: _authBloc
                                                                  .changeEmail,
                                                              textType:
                                                                  TextInputType
                                                                      .text,
                                                              height: 60.0,
                                                            );
                                                          }),
                                                      StreamBuilder(
                                                          stream: _authBloc
                                                              .password,
                                                          builder: (context,
                                                              snapshot) {
                                                            return InputTextMain(
                                                              fillColor: Color(
                                                                      0xD3D3D3)
                                                                  .withAlpha(
                                                                      50),
                                                              hintText:
                                                                  "Password...",
                                                              errorText:
                                                                  snapshot
                                                                      .error,
                                                              onChanged: _authBloc
                                                                  .changePassword,
                                                              textType:
                                                                  TextInputType
                                                                      .text,
                                                              height: 60.0,
                                                            );
                                                          }),
                                                      StreamBuilder(
                                                          stream: _authBloc
                                                              .signInStatus,
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      bool>
                                                                  snapshot) {
                                                            if (!snapshot.hasData ||
                                                                snapshot
                                                                    .hasError ||
                                                                !snapshot
                                                                    .data) {
                                                              return Container(
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                        height:
                                                                            45.0,
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            ButtonMainTextIcon(
                                                                          callback:
                                                                              () async {
                                                                            if (_authBloc.validateAllFields()) {
                                                                              _authBloc.showProgressBar(true);

                                                                              int response = await _authBloc.upgradeUserAccount();

                                                                              if (response < 0) {
                                                                                showErrorMessage("Could not register user. Maybe e-mail is already been taken");
                                                                              } else {
                                                                                await _authBloc.sendEmailConfirmation();
                                                                              }
                                                                              _authBloc.showProgressBar(false);
                                                                              Navigator.of(contextc).pop();
                                                                            } else {
                                                                              showErrorMessage("Invalid Form");
                                                                              Navigator.of(contextc).pop();
                                                                            }
                                                                          },
                                                                          bgColor:
                                                                              Color(0xFF5D7EB6),
                                                                          paddingLeft:
                                                                              0.0,
                                                                          paddingRight:
                                                                              0.0,
                                                                          text:
                                                                              "UPGRADE",
                                                                          textColor:
                                                                              Colors.white,
                                                                        )),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 15.0),
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          Builder(
                                                                        builder: (contextc) => Container(
                                                                            height: 45.0,
                                                                            child: ButtonMainTextIcon(
                                                                              callback: () async {
                                                                                Navigator.of(contextc).pop();
                                                                                _authBloc.showProgressBar(true);
                                                                                int response = await _authBloc.upgradeUserAccountWithGoogle();
                                                                                if(response < 0) {
                                                                                  showErrorMessage("This Google account is already in use");
                                                                                }
                                                                                _authBloc.showProgressBar(false);
                                                                                setState(() {
                                                                                });
                                                                              },
                                                                              bgColor: Colors.white,
                                                                              width: 170.0,
                                                                              paddingLeft: 0.0,
                                                                              imageSize: 25.0,
                                                                              paddingRight: 0.0,
                                                                              iconImagePath: 'assets/images/google_logo_g_transparent.png',
                                                                              text: "Sign In",
                                                                              textColor: Color(0xFF5D7EB6),
                                                                              spaceBetweenImageAndText: 10.0,
                                                                            )),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            } else {
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                              ));
                                                            }
                                                          })
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          'UPGRADE ACCOUNT',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
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
                        // REGULAR USER

                        if (!userSnapshot.data.isEmailVerified) {
                          // EMAIL NOT VERIFIED -- SHOW EMAIL CONFIRMATION SHEET

                          _blogBloc.setUserPermission(false);

                          return Positioned(
                            height: 160,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              decoration: const BoxDecoration(
                                color: Color(0xFF162A49),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(32)),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Hey !',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 3.0,
                                      ),
                                      Text(
                                        'You need to confirm your email!',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: InkWell(
                                          onTap: () async {
                                            await userSnapshot.data.reload();

                                            bool verified = await _userBloc
                                                .isEmailConfirmed();

                                            if (verified) {
                                              //Show confirmation message
                                              setState(() {});
                                              print(
                                                  "User already confirmed email");
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Email Confirmation"),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            'You need to confirm your email to proceed.',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              _authBloc
                                                                  .sendEmailConfirmation();
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top:
                                                                          15.0),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Card(
                                                                color:
                                                                    Colors.blue,
                                                                elevation: 8,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            32)),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                    'RESEND EMAIL VERIFICATION',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                          child: Container(
                                            child: Card(
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32)),
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  'VERIFY MY ACCOUNT',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15.0,
                                                      color: Colors.blueAccent),
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
                        } else {
                          // EMAIL VERIFIED -- SHOW USER DETAILS

                          _blogBloc.setUserPermission(false);

                          return StreamBuilder<DocumentSnapshot>(
                            stream:
                                _userBloc.getUserData(userSnapshot.data.uid),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                if (!snapshot.data.exists) {
                                  /// MEMBER USER ---------------------------------
                                  /// PROFILE NOT YET CREATED
                                  ///

                                  _blogBloc.setUserPermission(false);

                                  return Positioned(
                                    height: 160,
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
                                                  "Hello, ${userSnapshot.data.providerData[0].displayName}",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23.0,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'First, lets create your profile in our community',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
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
                                                              builder: (context) =>
                                                                  CreateProfilePage(
                                                                    userUID:
                                                                        userSnapshot
                                                                            .data
                                                                            .uid,
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

                                  _blogBloc.setUserPermission(true);

                                  _user = UserModel.fromDocument(snapshot.data);
                                  return Container(
                                    child: Stack(
                                      children: <Widget>[
                                        UserProfileBottomSheet(
                                          name: _user.name,
                                          industry: _user.industry,
                                          nationality: _user.nationality,
                                          about: _user.about,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(15.0),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: RectGetter(
                                              key: rectGetterKey,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 0.0),
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
                        }
                      }
                    } else {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFF3498db),
                        ),
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
