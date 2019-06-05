import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/models/UserModel.dart';
import 'package:buddies_osaka/src/blocs/user/UserBlocProvider.dart';
import 'package:buddies_osaka/src/blocs/user/UserBloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buddies_osaka/src/ui/CreateProfilePage.dart';
import 'package:buddies_osaka/src/ui/ProfilePage.dart';


class HomePage extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserBloc _userBloc;
  UserModel _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = UserBlocProvider.of(context);
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  Widget userCardData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0),
              child: Hero(
                tag: 'profileAvatar',
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 75.0,
                  width: 75.0,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(37.5),
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _user.image != null ? NetworkImage(
                              'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg') :
                              AssetImage("assets/images/user-image-placeholder.jpg")
                      )
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 195.0,
                  child: Text(
                    _user.name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                  width: 195.0,
                  child: Text(
                    _user.eMail,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black38,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                  width: 195.0,
                  child: Text(
                    _user.industry,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF204D9E),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget userCard() {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
//                          Route route = MaterialPageRoute(builder: (context) => ProfilePage(avatar: this._avatar, username: this._userName, projectId: this._userCurrentProject,transactions: this._transactions,));
//                          Navigator.push(context, route);
                  Route route = MaterialPageRoute(builder: (context) => ProfilePage(user: _user));
                  Navigator.push(context, route);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 0.0),
                  alignment: Alignment.center,
                  height: 150.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: _userBloc.isAnonym(),
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Text("USUÀRIO ANÔNIMO!!!");
                      }
                      else {
                        return FutureBuilder(
                          future: _userBloc.getUserUID(),
                          builder: (context, AsyncSnapshot<String> userDocId) {
                            if(userDocId.hasData && userDocId.data.length > 0) {
                              return StreamBuilder(
                                  stream: _userBloc.getUserData(userDocId.data),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if(snapshot.hasData && snapshot.data != null) {
                                      print("SNAPSHOT DATA 1: " + snapshot.data.exists.toString());

                                      if(!snapshot.data.exists) {
                                        return Container(
                                          margin: EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                                Text(
                                                  'Hello!',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 35.0,
                                                      color: Colors.black87),
                                                ),

                                                Text(
                                                  'First, lets create your profile in our community',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.0,
                                                      color: Colors.black54),
                                                ),
                                              SizedBox(height: 12.0,),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: InkWell(
                                                  onTap: () {
                                                    Route route = MaterialPageRoute(builder: (context) => CreateProfilePage(userUID: userDocId.data,));
                                                    Navigator.push(context, route);
                                                  },
                                                  child: Text(
                                                    'CREATE PROFILE',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Color(0xFF204D9E)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        _user = UserModel.fromDocument(snapshot.data);
                                        return userCardData();
                                      }
                                    } else {
                                      return Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(bottom: 15.0),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color(0xFF3498db),
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      );
                                    }
                                  });
                            } else {
                              return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 15.0),
                                child: CircularProgressIndicator(
                                  backgroundColor: Color(0xFF3498db),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF204D9E),
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Community",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            child:
            /** USER PROFILE CARD **/
            userCard(),
            /** END OF USER PROFILE CARD **/
          ),
          SizedBox(
            height: 25.0,
          ),

          /** ----------     BLOGS SIDE SCROLL AREA     ------------------ **/
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Blogs",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 25.0),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "VIEW ALL >",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, left: 15.0),
                height: 125.0,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _blogCard(),
                    SizedBox(width: 10.0),
                    _blogCard(),
                    SizedBox(width: 10.0),
                    _blogCard(),
                    SizedBox(width: 10.0),
                  ],
                ),
              )
            ],
          ),
          /** ---------        END OF BLOGS AREA        ------------------ **/
          SizedBox(
            height: 20.0,
          ),

          /** ----------     EVENTS SIDE SCROLL AREA     ------------------ **/
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Events",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 25.0),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "VIEW ALL >",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, left: 15.0),
                height: 205.0,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _eventCard(),
                    SizedBox(width: 10.0),
                    _eventCard(),
                    SizedBox(width: 10.0),
                    _eventCard(),
                    SizedBox(width: 10.0),
                  ],
                ),
              )
            ],
          ),
          /** ---------        END OF EVENTS AREA        ------------------ **/

          SizedBox(
            height: 20.0,
          ),

          /** ----------     QA SIDE SCROLL AREA     ------------------ **/
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Q&A's",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 25.0),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "VIEW ALL >",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, left: 15.0),
                margin: EdgeInsets.only(bottom: 20.0),
                height: 95.0,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _qAndACard(),
                    SizedBox(width: 10.0),
                    _qAndACard(),
                    SizedBox(width: 10.0),
                    _qAndACard(),
                    SizedBox(width: 10.0),
                  ],
                ),
              )
            ],
          ),
          /** ---------        END OF QA AREA        ------------------ **/
        ],
      ),
    );
  }

  Widget _qAndACard() {
    return Container(
      width: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 250.0,
                padding: EdgeInsets.only(left: 7.0, top: 7.0, right: 3.0),
                child: Text(
                  'Q: This is an auto generated question for testing purposes. What is',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 5.0, top: 7.0, right: 7.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 5.0),
                      Text(
                        "Henrique Dal Mora",
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eventCard() {
    return Container(
      width: 180.0,
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 95.0,
                    child: Container(
                      margin: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              topLeft: Radius.circular(12.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: FractionalOffset.topCenter,
                            image: AssetImage(
                                'assets/images/airport-placeholder.jpg'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Airport Opening",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    alignment: Alignment.center,
                    child: Text(
                      "JUN 06, 2019",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                          fontSize: 14.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    alignment: Alignment.center,
                    child: Text(
                      "FREE",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF204D9E),
                          fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blogCard() {
    return Container(
      height: 125.0,
      width: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 250.0,
                padding: EdgeInsets.only(left: 7.0, top: 7.0, right: 3.0),
                child: Text(
                  'My blog post title here',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 250.0,
                height: 30.0,
                padding: EdgeInsets.only(left: 7.0, top: 7.0, right: 7.0),
                child: Text(
                  'My blog post and all its content here',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 5.0, top: 7.0, right: 7.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 5.0),
                    Text(
                      "Henrique Dal Mora",
                      style: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: 5.0, left: 10.0, bottom: 0.0),
                          child: Text(
                            "01/06/2019",
                            style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 0.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 0.0),
                            child: Text(
                              '41',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2.0, right: 0.0),
                            child: Icon(
                              Icons.star,
                              size: 18.0,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 0.0),
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 0.0),
                            child: Text(
                              '1258',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2.0, right: 0.0),
                            child: Text(
                              'views',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
