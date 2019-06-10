import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/ui/widgets/description_text_widget.dart';
import 'package:buddies_osaka/src/models/UserModel.dart';


const double minHeight = 120;

const double iconStartSize = 44;

const double iconEndSize = 95;

const double iconStartMarginTop = 36;

const double iconEndMarginTop = 80;

const double iconsVerticalSpacing = 24;

const double iconsHorizontalSpacing = 16;

const double iconBorderRadius = 80.0;

class UserProfileBottomSheet extends StatefulWidget {

  final String name;
  final String industry;
  final String nationality;
  final String about;

  UserProfileBottomSheet({Key key, @required this.name, @required this.industry, @required this.nationality, @required this.about}) : super(key:key);

  @override
  _UserProfileBottomSheetState createState() => _UserProfileBottomSheetState(name, industry, nationality, about);
}

class _UserProfileBottomSheetState extends State<UserProfileBottomSheet>
    with SingleTickerProviderStateMixin {

  final String name;
  final String industry;
  final String nationality;
  final String about;

  _UserProfileBottomSheetState(this.name, this.industry, this.nationality, this.about);

  AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height - 80;

  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get headerFontSize => lerp(14, 24);

  double get itemBorderRadius => lerp(8, 24);

  double get iconLeftBorderRadius => itemBorderRadius;

  double get iconRightBorderRadius => lerp(8, 0);

  double get iconSize => lerp(iconStartSize, iconEndSize);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          height: lerp(minHeight, maxHeight),
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF162A49),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                children: <Widget>[
                  _buildFullItem(),
                  _buildItem(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem() {
    return Positioned(
      height: iconSize,
      width: iconSize,
      top: 30,
      left: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(iconBorderRadius),
          right: Radius.circular(iconBorderRadius),
        ),
        child: Image.asset(
          'assets/images/user-image-placeholder.jpg',
          fit: BoxFit.cover,
          alignment: Alignment(lerp(1, 0), 0),
        ),
      ),
    );
  }

  Widget _buildFullItem() {
    return ExpandedItem(
      topMargin: 80,
      leftMargin: 0,
      height: 250,
      isVisible: _controller.status == AnimationStatus.completed,
      borderRadius: itemBorderRadius,
      name: name,
      industry: industry,
      nationality: nationality,
      about: about,
    );
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;

    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }
}

class ExpandedItem extends StatelessWidget {
  final double topMargin;

  final double leftMargin;

  final double height;

  final bool isVisible;

  final double borderRadius;

  final String name;

  final String industry;

  final String nationality;

  final String about;

  const ExpandedItem(
      {Key key,
      this.topMargin,
      this.height,
      this.isVisible,
      this.borderRadius,
      this.name,
      this.industry,
      this.nationality,
      this.about,
      this.leftMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 16.0).add(EdgeInsets.all(8)),
          child: _buildDetailsContent(),
        ),
      ),
    );
  }

  Widget _buildDetailsContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: iconEndSize / 2),

        Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,

              fontSize: 17.0),
        ),

        SizedBox(height: 2),

        Text(
          industry,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color(0xFF204D9E)),
        ),

        SizedBox(height: 6),

        Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.grey.shade400, size: 16),
            Text(
              nationality,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            )
          ],
        ),

        SizedBox(height: 2),

        Container(
          child:
          DescriptionTextWidget(text: about),
        ),

        SizedBox(width: 8),

//        Spacer(),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback callback;

  const MenuButton({Key key, @required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 24,
      child: InkWell(
        onTap: callback,
        child: Icon(
          Icons.menu,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
