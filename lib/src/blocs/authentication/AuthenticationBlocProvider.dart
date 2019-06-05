import 'package:flutter/material.dart';
import 'AuthenticationBloc.dart';
export 'AuthenticationBloc.dart';

class AuthenticationBlocProvider extends InheritedWidget{
  final bloc = AuthenticationBloc();

  AuthenticationBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AuthenticationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthenticationBlocProvider) as AuthenticationBlocProvider).bloc;
  }
}