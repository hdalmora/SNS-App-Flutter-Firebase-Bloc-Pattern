import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/widgets/events_sliding_cards.dart';

class Events extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5),

                    EventsSlidingCardsView(),
                    Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(

                            "View All >",

                            style: TextStyle(

                              fontSize: 18,

                              color: Colors.black45, //: Colors.grey,

                              fontWeight:FontWeight.w800,

                            ),

                          ),
                        ],
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
