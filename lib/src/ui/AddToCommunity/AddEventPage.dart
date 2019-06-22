import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBloc.dart';
import 'package:buddies_osaka/src/blocs/blogs/BlogBlocProvider.dart';
import 'package:buddies_osaka/src/components/button-main-text-icon.dart';

class AddEventPage extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BlogBloc _blogBloc;

  String _startDatePicked = "";
  String _startTimePicked = "";

  String _endDatePicked = "";
  String _endTimePicked = "";

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
            "new Event",
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
                            hintText: "Event title..",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF2ECC71)))),
                      );
                    }),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Text(
                              "Start date",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: StreamBuilder(
                                //stream: _userBloc.dateOfArrival,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                              return Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      child: Material(
                                        color: Colors.blue,
                                        elevation: 1.0,
                                        child: GestureDetector(
                                          onTap: () async {
                                            DateTime picked =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        new DateTime.now(),
                                                    firstDate:
                                                        new DateTime(2016),
                                                    lastDate:
                                                        new DateTime(2020));
                                            if (picked != null) {
//                                              _userBloc
//                                                  .changeDate(picked.toString());
                                              setState(() {
                                                this._startDatePicked =
                                                    picked.toString();
                                              });
                                            }
                                          },
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.all(15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.date_range,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 0.0, left: 10.0),
                                      child: Text(
                                        _startDatePicked.length >= 10
                                            ? _startDatePicked.substring(0, 10)
                                            : "You must pick a start date.",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: _startDatePicked.length >= 10
                                                ? Colors.black38
                                                : Colors.red,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Text(
                              "Start time",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: StreamBuilder(
                                //stream: _userBloc.dateOfArrival,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                              return Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      child: Material(
                                        color: Colors.blue,
                                        elevation: 1.0,
                                        child: GestureDetector(
                                          onTap: () async {
                                            DateTime picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate:
                                                new DateTime.now(),
                                                firstDate:
                                                new DateTime(2016),
                                                lastDate:
                                                new DateTime(2020));
                                            if (picked != null) {
//                                              _userBloc
//                                                  .changeDate(picked.toString());
                                              setState(() {
                                                this._startTimePicked =
                                                    picked.toString();
                                              });
                                            }
                                          },
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.all(15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      margin:
                                      EdgeInsets.only(top: 0.0, left: 10.0),
                                      child: Text(
                                        _startTimePicked.length >= 10
                                            ? _startTimePicked.substring(0, 10)
                                            : "You must pick a start time.",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: _startTimePicked.length >= 10
                                                ? Colors.black38
                                                : Colors.red,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200.0,
                margin: EdgeInsets.only(bottom: 15.0, top: 15.0),
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
                            hintText: "Event description...",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF2ECC71)))),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder(
                    stream: _blogBloc.submissionStatus,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.hasError ||
                          !snapshot.data) {
                        return Container(
                            margin: EdgeInsets.only(top: 30.0),
                            height: 45.0,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: ButtonMainTextIcon(
                              callback: () async {
                                if (_blogBloc.validateFields()) {
                                  await _blogBloc.submit();

                                  showErrorMessage(
                                      "New Blog posted successfully!");
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
