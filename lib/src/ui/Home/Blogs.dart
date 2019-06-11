import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/widgets/blogs_sliding_cards.dart';

class Blogs extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
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

                    BlogsSlidingCardsView(),
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
