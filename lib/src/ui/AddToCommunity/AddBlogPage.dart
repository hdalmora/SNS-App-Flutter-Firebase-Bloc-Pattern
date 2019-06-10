import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:buddies_osaka/src/components/button-main-text-icon.dart';

class AddBlogPage extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BlogBloc _blogBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogBloc = BlogBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _blogBloc.dispose();
  }

  void showErrorMessage(String message) {
    final snackbar =
    SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "new Blog Post",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.black54),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.grey,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: StreamBuilder(
                    stream: _blogBloc.title,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return TextField(
                        onChanged: _blogBloc.changeTitle,
                        decoration: InputDecoration(
                            filled: true,
                            enabledBorder: InputBorder.none,
                            errorText: snapshot.error,
                            hintText: "Blog title..",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF2ECC71)))),
                      );
                    }),
              ),
              Container(
                height: 200.0,
                margin: EdgeInsets.only(bottom: 15.0),
                child: StreamBuilder(
                    stream: _blogBloc.content,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return TextField(
                        onChanged: _blogBloc.changeContent,
                        keyboardType: TextInputType.multiline,
                        maxLines: 820,
                        decoration: InputDecoration(
                            filled: true,
                            errorText: snapshot.error,
                            enabledBorder: InputBorder.none,
                            hintText: "Content...",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF2ECC71)))),
                      );
                    }),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder(
                  stream: _blogBloc.submissionStatus,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (!snapshot.hasData || snapshot.hasError || !snapshot.data) {
                      return Container(
                          margin: EdgeInsets.only(top: 30.0),
                          height: 45.0,
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: ButtonMainTextIcon(
                            callback: () async {
                              if(_blogBloc.validateFields()) {
                                await _blogBloc.submit();

                                showErrorMessage("New Blog posted successfully!");
                              } else {
                                showErrorMessage("Invalid fields");
                              }
                            },
                            bgColor: Colors.lightBlue,
                            paddingLeft: 0.0,
                            paddingRight: 0.0,
                            width: 220.0,
                            text: "Create",
                            textColor: Colors.white,
                          ));
                    } else {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xFF3498db),
                        ),
                      );
                    }
                  }),
              ),
            ],
          ),
        ));
  }
}