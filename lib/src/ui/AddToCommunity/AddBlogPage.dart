import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:buddies_osaka/src/components/button-main-text-icon.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:async';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class AddBlogPage extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ZefyrController _controller;
  FocusNode _focusNode;

  BlogBloc _blogBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogBloc = BlogBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();

    final document = new NotusDocument();
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _blogBloc.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  void showErrorMessage(String message) {
    final snackbar =
    SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
        cursorColor: Colors.blue,
        toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
          color: Colors.blue.shade800,
          toggleColor: Colors.blue.shade900,
          iconColor: Colors.white,
          disabledIconColor: Colors.blue.shade500,
        ));

    final post = [FlatButton(
        onPressed: () async {
          _blogBloc.changeContent(json.encode(_controller.document));
          if(_blogBloc.validateFields()) {
            await _blogBloc.submit();
            Navigator.of(context).pop();
          } else {
            print("CONTENT WRONG FORMAT");
          }
          _blogBloc.changeContent("");
        },
        child: Text('POST'))];

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.blue.shade200,
        brightness: Brightness.light,
        title: Text("new Blog Post"),
        actions: post,
      ),
      body: ZefyrScaffold(
        child:
        ZefyrTheme(
          data: theme,
          child: ListView(
            children: <Widget>[

              Container(
                child: StreamBuilder(
                    stream: _blogBloc.title,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return TextField(
                        onChanged: _blogBloc.changeTitle,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: InputBorder.none,
                            errorText: snapshot.error,
                            hintText: "Blog title..",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue))),
                      );
                    }),
              ),


              Container(
                alignment: Alignment.center,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text("+ Add Picture",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: new IconButton(
                              icon: new Icon(Icons.image, color: Colors.blue,),
                              onPressed: ()  {
                              },
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),


              ZefyrField(
                height: MediaQuery.of(context).size.height*0.65,
                decoration: InputDecoration(labelText: "Blog content....."),
                controller: _controller,
                focusNode: _focusNode,
                enabled: true,
//            imageDelegate: new CustomImageDelegate(),
              ),


            ],
          ),
        ),
      ),
    );




















//      Scaffold(
//        key: _scaffoldKey,
//        backgroundColor: Colors.white,
//        resizeToAvoidBottomPadding: false,
//        appBar: AppBar(
//          elevation: 0.0,
//          title: Text(
//            "new Blog Post",
//            style: TextStyle(
//                fontWeight: FontWeight.bold,
//                fontSize: 22.0,
//                color: Colors.black54),
//          ),
//          centerTitle: true,
//          backgroundColor: Colors.white,
//          leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//            color: Colors.grey,
//          ),
//        ),
//        body: Padding(
//          padding: EdgeInsets.all(20.0),
//          child: Column(
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(bottom: 15.0),
//                child:
//
//                StreamBuilder(
//                    stream: _blogBloc.title,
//                    builder: (context, AsyncSnapshot<String> snapshot) {
//                      return TextField(
//                        onChanged: _blogBloc.changeTitle,
//                        decoration: InputDecoration(
//                            filled: true,
//                            enabledBorder: InputBorder.none,
//                            errorText: snapshot.error,
//                            hintText: "Blog title..",
//                            labelStyle: TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey),
//                            focusedBorder: UnderlineInputBorder(
//                                borderSide: BorderSide(
//                                    color: Color(0xFF2ECC71)))),
//                      );
//                    }),
//              ),
//              Container(
//                height: 200.0,
//                margin: EdgeInsets.only(bottom: 15.0),
//                child: StreamBuilder(
//                    stream: _blogBloc.content,
//                    builder: (context, AsyncSnapshot<String> snapshot) {
//                      return TextField(
//                        onChanged: _blogBloc.changeContent,
//                        keyboardType: TextInputType.multiline,
//                        maxLines: 820,
//                        decoration: InputDecoration(
//                            filled: true,
//                            errorText: snapshot.error,
//                            enabledBorder: InputBorder.none,
//                            hintText: "Content...",
//                            labelStyle: TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey),
//                            focusedBorder: UnderlineInputBorder(
//                                borderSide: BorderSide(
//                                    color: Color(0xFF2ECC71)))),
//                      );
//                    }),
//              ),
//
//              Align(
//                alignment: Alignment.bottomCenter,
//                child: StreamBuilder(
//                  stream: _blogBloc.submissionStatus,
//                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//                    if (!snapshot.hasData || snapshot.hasError || !snapshot.data) {
//                      return Container(
//                          margin: EdgeInsets.only(top: 30.0),
//                          height: 45.0,
//                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                          child: ButtonMainTextIcon(
//                            callback: () async {
//                              if(_blogBloc.validateFields()) {
//                                await _blogBloc.submit();
//
//                                showErrorMessage("New Blog posted successfully!");
//
//                              } else {
//                                showErrorMessage("Invalid fields");
//                              }
//                            },
//                            bgColor: Colors.lightBlue,
//                            paddingLeft: 0.0,
//                            paddingRight: 0.0,
//                            width: 220.0,
//                            text: "Create",
//                            textColor: Colors.white,
//                          ));
//                    } else {
//                      return Container(
//                        alignment: Alignment.bottomCenter,
//                        margin: EdgeInsets.only(bottom: 15.0),
//                        child: CircularProgressIndicator(
//                          backgroundColor: Color(0xFF3498db),
//                        ),
//                      );
//                    }
//                  }),
//              ),
//            ],
//          ),
//        ));
  }
}
