import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF204D9E),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              child: Text(
                "Chat List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 32.0,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Flexible(
            flex: 5,
            child: Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
//                  height: 430.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  _chatCard("Henrique", "Unavailable", 1),
                  SizedBox(height: 60.0),
                  _chatCard("Burak", "Available", 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatCard(String name, String status, int cardIndex) {
    return new Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Stack(children: <Widget>[
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
            Container(
              height: 15.0,
              width: 15.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: status == 'Unavailable' ? Colors.grey : Colors.green,
                  border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 2.0)),
            )
          ]),
        ),
        Flexible(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10.0),
                alignment: Alignment.topLeft,
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 2.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "This is the last message received from your contact",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    fontSize: 15.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "09:13 AM",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black26,
                    fontSize: 11.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 7.0),
                height: 21.0,
                width: 21.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.green,
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2.0)),
                child: Text(
                  "5",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 12.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
