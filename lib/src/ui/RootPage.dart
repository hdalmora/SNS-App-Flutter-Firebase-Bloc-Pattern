import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/resources/AuthenticationResources.dart';
import 'dart:async';
import 'package:buddies_osaka/src/ui/NavigationPage.dart';
import 'package:buddies_osaka/src/ui/LoginPage.dart';

class RootPage extends StatefulWidget {
  static const String routeName = 'root_screen';

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final AuthenticationResources _authentication = AuthenticationResources();
  Stream<FirebaseUser> currentUser;

  @override
  void initState() {
    currentUser = _authentication.onAuthStateChange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        return snapshot.hasData ? NavigationPage() : LoginPage();
      },
    );
  }
}
