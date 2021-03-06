import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'dart:math' as math;



class EventsSlidingCardsView extends StatefulWidget {

  @override

  _EventsSlidingCardsViewState createState() => _EventsSlidingCardsViewState();

}



class _EventsSlidingCardsViewState extends State<EventsSlidingCardsView> {

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

      height: MediaQuery.of(context).size.height * 0.50,

      child: PageView(

        controller: pageController,

        children: <Widget>[

          SlidingCard(

            name: 'Airport opening event',

            date: '01/06/2016',

            assetName: 'images/airport-placeholder.jpg',

            offset: pageOffset,

          ),

          SlidingCard(

            name: 'Airport opening event',

            date: '01/06/2016',

            assetName: 'images/airport-placeholder.jpg',

            offset: pageOffset - 1,

          ),

        ],

      ),

    );

  }

}



class SlidingCard extends StatelessWidget {

  final String name;

  final String date;

  final String assetName;

  final double offset;



  const SlidingCard({

    Key key,

    @required this.name,

    @required this.date,

    @required this.assetName,

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

            ClipRRect(

              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),

              child: Image.asset(

                'assets/$assetName',

                height: MediaQuery.of(context).size.height * 0.3,

                alignment: Alignment(-offset.abs(), 0),

                fit: BoxFit.none,

              ),

            ),

            SizedBox(height: 8),

            Expanded(

              child: CardContent(

                name: name,

                date: date,

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

  final String name;

  final String date;

  final double offset;



  const CardContent(

      {Key key,

        @required this.name,

        @required this.date,

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

            child: Text(name, style: TextStyle(fontSize: 20)),

          ),

          SizedBox(height: 8),

          Transform.translate(

            offset: Offset(32 * offset, 0),

            child: Text(

              date,

              style: TextStyle(color: Colors.grey),

            ),

          ),

          Spacer(),

          Row(

            children: <Widget>[
              Spacer(),

              Transform.translate(

                offset: Offset(32 * offset, 0),

                child: Text(

                  '0.00 \$',

                  style: TextStyle(

                    fontWeight: FontWeight.bold,

                    fontSize: 20,

                  ),

                ),

              ),

              SizedBox(width: 16),

            ],

          )

        ],

      ),

    );

  }

}