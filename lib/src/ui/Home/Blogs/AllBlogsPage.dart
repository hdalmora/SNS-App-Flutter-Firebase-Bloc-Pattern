import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/widgets/blogs_sliding_cards_vertical.dart';

class AllBlogsPage extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _AllBlogsPageState createState() => _AllBlogsPageState();
}

class _AllBlogsPageState extends State<AllBlogsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("All Blogs", style: TextStyle(
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
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: BlogsVerticalSlidingCardsView(),
          ),
        ],
      ),
    );
  }
}
