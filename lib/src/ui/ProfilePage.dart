import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/widgets/description-text-widget.dart';
import 'package:buddies_osaka/src/models/UserModel.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = 'profile_screen';

  final UserModel user;

  ProfilePage({Key key, this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState(user: user);
}

class _ProfilePageState extends State<ProfilePage> {
  final UserModel user;

  _ProfilePageState({Key key, this.user});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 200.0,
                width: double.infinity,
                color: Color(0xFF204D9E),

              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 125.0, right: 15.0, left: 15.0),

                child: Material(

                  elevation: 3.0,

                  borderRadius: BorderRadius.circular(7.0),

                  child: Container(
                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(7.0),

                        color: Colors.white),

                    child: Container(
                      margin: EdgeInsets.only(top: 60.0, bottom: 15.0, left: 15.0, right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(

                            user.name,

                            style: TextStyle(

                                fontFamily: 'Montserrat',

                                fontWeight: FontWeight.bold,

                                fontSize: 17.0),

                          ),

                          SizedBox(height: 7.0),

                          Text(

                            user.industry,

                            style: TextStyle(

                                fontFamily: 'Montserrat',

                                fontWeight: FontWeight.bold,

                                fontSize: 17.0,

                                color: Color(0xFF204D9E)),

                          ),

                          SizedBox(height: 7.0),

                          Text(

                            user.nationality,

                            style: TextStyle(

                                fontFamily: 'Montserrat',

                                fontWeight: FontWeight.bold,

                                fontSize: 17.0,

                                color: Colors.grey),

                          ),

                          SizedBox(height: 10.0),

                          Container(
                            child:
                            DescriptionTextWidget(text: user.about),
                          ),

                          SizedBox(height: 10.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              FlatButton(

                                shape: RoundedRectangleBorder(

                                  borderRadius: BorderRadius.circular(7.0),

                                ),

                                color: Color(0xFF204D9E),

                                onPressed: () {},

                                child: Text(

                                  'Message',

                                  style: TextStyle(

                                      fontFamily: 'Montserrat',

                                      fontWeight: FontWeight.bold,

                                      fontSize: 15.0,

                                      color: Colors.white),

                                ),

                              ),

                            ],

                          )
                        ],
                      ),
                    ),

                  ),

                ),

              ),

              Align(

                alignment: Alignment.topLeft,

                child: IconButton(

                  icon: Icon(Icons.arrow_back_ios),

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  color: Colors.white,

                ),

              ),



              Positioned(

                top: 75.0,

                left: (50.0),

                child: Hero(
                  tag: 'profileAvatar',
                  child: Container(
                    height: 100.0,

                    width: 100.0,

                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(50.0),

                        image: DecorationImage(

                            image: AssetImage(
                                'assets/images/user-image-placeholder.jpg'),

                            fit: BoxFit.cover)),

                  ),
                ),
              ),

            ],

          ),
          SizedBox(height: 10.0),

          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 25.0, bottom: 20.0),
                  child: Text(
                    "User Activity",
                    style: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Blogs",
                        style: TextStyle(
                            color: Colors.black87,
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
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Events",
                        style: TextStyle(
                            color: Colors.black87,
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
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
