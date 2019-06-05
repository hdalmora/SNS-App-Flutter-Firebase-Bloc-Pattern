import 'package:flutter/material.dart';

class ButtonMainTextIcon extends StatelessWidget {
  final Color bgColor;
  final textColor;
  final String text;
  final String iconImagePath;
  final VoidCallback callback;
  final double height;
  final double paddingLeft;
  final double paddingRight;
  final double width;
  final double spaceBetweenImageAndText;
  final double imageSize;

  const ButtonMainTextIcon({
    Key key,
    this.callback,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
    this.text = "",
    this.iconImagePath = "",
    this.height = 60.0,
    this.width,
    this.paddingLeft = 20.0,
    this.paddingRight = 20.0,
    this.spaceBetweenImageAndText = 10.0,
    this.imageSize = 40.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: this.height,
      width: this.width,
      padding: EdgeInsets.only(left: this.paddingLeft, right: this.paddingRight),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: bgColor,
        elevation: 1.0,
        child: GestureDetector(
          onTap: callback,
          child: Center(
            child: iconImagePath.length <= 0 ? Text(
              text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  fontFamily: 'Montserrat'
              ),
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    height: imageSize,
                    child: Image.asset(iconImagePath, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: spaceBetweenImageAndText),
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}