import 'dart:io';

import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:async';
import 'dart:convert';


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

  bool _loading = false;

  String _imagePath = "";
  bool _imageSelected = false;

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

    final loadingAction = [Container(
      child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          )),
    )];

    final post = [FlatButton(
      onPressed: () async {
        _blogBloc.changeContent(json.encode(_controller.document));
        if(_blogBloc.validateFields()) {
          setState(() {
            _loading = true;
          });
          String blogUID = await _blogBloc.submit();

          if(blogUID != null && blogUID.length > 0 && _imagePath.length > 0) {
            await _blogBloc.uploadImageToStorage(_imagePath, blogUID);
            _blogBloc.showProgressBar(false);
          }

          setState(() {
            _loading = false;
          });

          Navigator.of(context).pop();
        } else {
          print("CONTENT WRONG FORMAT");
        }
        _blogBloc.changeContent("");
      },
      child: Text("POST"),)];

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.blue.shade200,
        brightness: Brightness.light,
        title: Text("new Blog Post"),
        actions: !_loading ? post : loadingAction,
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
                child: InkWell(
                  onTap: () async {
                    String imagePath = await _blogBloc.getImagePath();

                    if(imagePath != null && imagePath.length > 0) {
                      setState(() {
                        _imagePath = imagePath;
                        _imageSelected = true;
                      });
                      print("Image Path: ${_imagePath.toString()}");
                    }
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      child: _imageSelected == false ? Row(
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
                      ) : Image.file(File(_imagePath)),
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
  }
}
