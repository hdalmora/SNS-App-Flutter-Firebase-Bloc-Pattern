import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'dart:math' as math;



class QuestionsSlidingCardsView extends StatefulWidget {

  @override

  _QuestionsSlidingCardsViewState createState() => _QuestionsSlidingCardsViewState();

}



class _QuestionsSlidingCardsViewState extends State<QuestionsSlidingCardsView> {

  PageController pageController;

  double pageOffset = 0;



  @override

  void initState() {

    super.initState();

    pageController = PageController(viewportFraction: 0.8);

    pageController.addListener(() {

      setState(() => pageOffset = pageController.page);

    });

  }



  @override

  void dispose() {

    pageController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return SizedBox(

      height: MediaQuery.of(context).size.height * 0.201,

      child: PageView(

        controller: pageController,

        children: <Widget>[

          SlidingCard(

            question: 'Q: This is an auto generated question for testing purposes, i would like to know how can I learn to develop mobile applications for Android and IOs',

            author: 'Henrique Dal Mora',

            offset: pageOffset,

          ),

          SlidingCard(

            question: 'Q: This is an auto generated question for testing purposes, i would like to know how can I learn to develop mobile applications for Android and IOs',

            author: 'My blog post and all its content are displayed here',

            offset: pageOffset - 1,

          ),

          SlidingCard(

            question: 'Q: This is an auto generated question for testing purposes, i would like to know how can I learn to develop mobile applications for Android and IOs',

            author: 'Henrique Dal Mora',

            offset: pageOffset - 2,

          ),

          SlidingCard(

            question: 'Q: This is an auto generated question for testing purposes, i would like to know how can I learn to develop mobile applications for Android and IOs',

            author: 'Henrique Dal Mora',

            offset: pageOffset - 3,

          ),

        ],

      ),

    );

  }

}



class SlidingCard extends StatelessWidget {

  final String question;

  final String author;

  final double offset;



  const SlidingCard({

    Key key,

    @required this.question,

    @required this.author,

    @required this.offset,

  }) : super(key: key);



  @override

  Widget build(BuildContext context) {

    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    return Transform.translate(

      offset: Offset(-32 * gauss * offset.sign, 0),

      child: Card(

        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),

        elevation: 8,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),

        child: Column(

          children: <Widget>[

            SizedBox(height: 8),

            Expanded(

              child: CardContent(

                question: question,

                author: author,

                offset: gauss,

              ),

            ),

          ],

        ),

      ),

    );

  }

}



class CardContent extends StatelessWidget {

  final String question;

  final String author;

  final double offset;



  const CardContent(

      {Key key,

        @required this.question,

        @required this.author,

        @required this.offset})

      : super(key: key);



  @override

  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.all(8.0),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[

          Transform.translate(

            offset: Offset(8 * offset, 0),

            child: Text(
              question,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
              ),
            ),

          ),

          SizedBox(height: 8),

          Transform.translate(

            offset: Offset(8 * offset, 0),

            child: Text(
              author,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45
              ),

            ),
          ),
        ],

      ),

    );

  }

}