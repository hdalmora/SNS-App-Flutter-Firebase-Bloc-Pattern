import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/user/UserBlocProvider.dart';
import 'package:buddies_osaka/src/ui/LoginPage.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBlocProvider.dart';
import 'package:buddies_osaka/src/ui/Home/HomePage.dart';
import 'package:buddies_osaka/src/ui/RootPage.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';

class BuddyOsakaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationBlocProvider(
      child: UserBlocProvider(
        child: BlogBlocProvider(
          child: MaterialApp(
            title: 'Buddy Osaka',
            theme: ThemeData(
              accentColor: Colors.blueAccent,
              primarySwatch: Colors.blue,
              fontFamily: 'SF Pro Display',
            ),
            initialRoute: RootPage.routeName,
            routes: {
              LoginPage.routeName: (context) => LoginPage(),
              HomePage.routeName: (context) => HomePage(),
              RootPage.routeName: (context) => RootPage(),
            },
          ),
        ),
      ),
    );
  }
}
