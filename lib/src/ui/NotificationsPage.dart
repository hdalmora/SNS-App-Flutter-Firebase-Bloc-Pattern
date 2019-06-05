import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Notifications",
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
        ],
      ),
    );
  }
}
