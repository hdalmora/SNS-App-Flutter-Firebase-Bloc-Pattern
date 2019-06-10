import 'package:flutter/material.dart';

class UpperTab extends StatelessWidget {

  final String text;

  final bool isSelected;

  final VoidCallback callback;



  const UpperTab({Key key, @required this.isSelected, @required this.text, @required this.callback})

      : super(key: key);



  @override

  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.all(0.0),

      child: GestureDetector(
        onTap: this.callback,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

            Text(

              text,

              style: TextStyle(

                fontSize: isSelected ? 25 : 21,

                color: isSelected ? Colors.black : Colors.grey,

                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,

              ),

            ),

            Container(

              height: 6,

              width: 20,

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(4),

                color: isSelected ? Colors.blueAccent : Colors.white,

              ),

            )

          ],

        ),
      ),



    );

  }

}