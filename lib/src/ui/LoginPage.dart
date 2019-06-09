import 'package:flutter/material.dart';

import 'package:buddies_osaka/src/ui/widgets/authentication_form.dart';



class LoginPage extends StatelessWidget {
  static const String routeName = 'login_screen';

  @override
  Widget build(BuildContext context) {

    return Container(

      child: AuthenticationForm(),

    );

  }

}