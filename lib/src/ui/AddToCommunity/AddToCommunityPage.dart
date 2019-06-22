import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/components/button-main-text-icon.dart';
import 'package:buddies_osaka/src/ui/AddToCommunity/AddBlogPage.dart';
import 'package:buddies_osaka/src/ui/AddToCommunity/AddEventPage.dart';


class AddToCommunityPage extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _AddToCommunityPageState createState() => _AddToCommunityPageState();
}

class _AddToCommunityPageState extends State<AddToCommunityPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Create", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black54),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.grey,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 45.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ButtonMainTextIcon(
                        callback: () async {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => AddBlogPage()));
                        },
                        bgColor: Colors.white,
                        paddingLeft: 0.0,
                        paddingRight: 0.0,
                        width: 220.0,
                        text: "Blog Post",
                        textColor: Color(0xFF5D7EB6),
                      )),

                  SizedBox(height: 15.0,),

                  Container(
                      height: 45.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ButtonMainTextIcon(
                        callback: () async {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => AddEventPage()));
                        },
                        bgColor: Colors.white,
                        paddingLeft: 0.0,
                        paddingRight: 0.0,
                        width: 220.0,
                        text: "Event",
                        textColor: Color(0xFF5D7EB6),
                      )),

                  SizedBox(height: 15.0,),

                  Container(
                      height: 45.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ButtonMainTextIcon(
                        callback: () async {

                        },
                        bgColor: Colors.white,
                        paddingLeft: 0.0,
                        paddingRight: 0.0,
                        width: 220.0,
                        text: "Question",
                        textColor: Color(0xFF5D7EB6),
                      )),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
