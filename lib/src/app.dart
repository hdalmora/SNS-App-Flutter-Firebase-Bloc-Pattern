import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/user/UserBlocProvider.dart';
import 'package:buddies_osaka/src/ui/LoginPage.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBlocProvider.dart';
import 'package:buddies_osaka/src/ui/HomePage.dart';
import 'package:buddies_osaka/src/ui/RootPage.dart';

class BuddyOsakaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationBlocProvider(
      child: UserBlocProvider(
        child: MaterialApp(
          title: 'Buddy Osaka',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Montserrat',
          ),
          initialRoute: RootPage.routeName,
          routes: {
            LoginPage.routeName: (context) => LoginPage(),
            HomePage.routeName: (context) => HomePage(),
            RootPage.routeName: (context) => RootPage(),
          },
        ),
      ),
    );
  }
}
