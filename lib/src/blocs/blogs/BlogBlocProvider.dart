import 'package:flutter/material.dart';
import 'BlogBloc.dart';
export 'BlogBloc.dart';

class BlogBlocProvider extends InheritedWidget{
  final bloc = BlogBloc();

  BlogBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BlogBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlogBlocProvider) as BlogBlocProvider).bloc;
  }
}