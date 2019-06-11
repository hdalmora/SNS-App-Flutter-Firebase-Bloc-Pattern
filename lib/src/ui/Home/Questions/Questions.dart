import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/widgets/question_sliding_cards_horizontal.dart';

class Questions extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
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

                    QuestionsSlidingCardsView(),
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
