import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/blocs/user/UserBlocProvider.dart';
import 'package:buddies_osaka/src/blocs/user/UserBloc.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:language_pickers/language.dart';
import 'package:language_pickers/language_pickers.dart';

class CreateProfilePage extends StatefulWidget {
  static const String routeName = 'root_screen';

  final String userUID;

  CreateProfilePage({Key key, this.userUID});

  @override
  _CreateProfilePageState createState() =>
      _CreateProfilePageState(userUID: userUID);
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String userUID;
  String _datePicked = "";
  Country _selectedCountry;

  _CreateProfilePageState({Key key, this.userUID});

  UserBloc _userBloc;

  // init the step to 0th position
  int currentStep = 0;
  int numberOfSteps = 6;

  Map<String, String> _languagesMap = Map<String, String>();
  List<DropdownMenuItem<String>> _dropDownLanguageMenuItems;
  List _languageLevels = ["Basic", "intermediate", "Advanced"];

  String _selectedIndustry;
  List<DropdownMenuItem<String>> _dropDownIndustryMenuItems;
  List _industryLabels = [
    "Agriculture, Forestry, Fishing and Hunting",

    "Mining",

    "Utilities",

    "Construction/Architecture",

    "Manufacturing",

    "Wholesale Trade",

    "Retail Trade",

    "Transportation and Warehousing",

    "Finance and Insurance",

    "Software",

    "Professional, Scientific, and Technical Services",

    "Management of Companies and Enterprises",

    "Educational Services",

    "Health Care and Social Assistance",

    "Arts, Entertainment, and Recreation",

    "Accommodation and Food Services",

    "Other Services (except Public Administration)",

    "Consulting",

    "Public Administration",

    "Non-profit",

    "Other",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = UserBlocProvider.of(context);
    _userBloc.changeNationality(Country.US.name);
    _userBloc.changeIndustry(_industryLabels[0]);
  }

  @override
  void initState() {
    _dropDownLanguageMenuItems = getDropDownMenuItems(_languageLevels);
    _dropDownIndustryMenuItems = getDropDownMenuItems(_industryLabels);
    setState(() {
      _selectedIndustry = _industryLabels[0];
      _selectedCountry = Country.US;
    });
    super.initState();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(List list) {
    List<DropdownMenuItem<String>> items = new List();
    for (String level in list) {
      items.add(new DropdownMenuItem(value: level, child: new Text(level)));
    }
    return items;
  }

  void changedDropDownItemToLanguagesMap(
      String selectedLanguage, String selectedLevel) {
    if (_languagesMap.containsKey(selectedLanguage)) {
      setState(() {
        _languagesMap[selectedLanguage] = selectedLevel;
        _userBloc.changeLanguage(_languagesMap);
        print("UPDATED LEVEL -- MAP: " + _languagesMap.toString());
      });
    }
  }

  void showErrorMessage(String message) {
    final snackbar =
        SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  List<Widget> languageWidget() {
    List<Widget> widgetList = List<Widget>();
    _languagesMap.forEach((language, level) {
      widgetList.add(_languageItem(language, level));
    });
    return widgetList;
  }

  Widget _languageItem(String language, String level) => Container(
        margin: EdgeInsets.all(0.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _languagesMap.remove(language);
                      _userBloc.changeLanguage(_languagesMap);
                      print("REMOVED -- MAP: " + _languagesMap.toString());
                    });
                  },
                  color: Colors.grey,
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(right: 50.0),
                child: Text(language),
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: DropdownButton(
                  value: _languagesMap[language],
                  items: _dropDownLanguageMenuItems,
                  onChanged: (selectedLevel) {
                    changedDropDownItemToLanguagesMap(language, selectedLevel);
                  },
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDialogItem(Language language) => Row(
        children: <Widget>[
          Text(language.name),
          SizedBox(width: 8.0),
          Flexible(child: Text("(${language.isoCode})"))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Create Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              fontFamily: 'Montserrat',
              color: Colors.black54),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.grey,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 70.0),
        alignment: Alignment.topLeft,
        child: Stepper(
          currentStep: this.currentStep,
          steps: [
            new Step(
                // Title of the Step
                title: Text(
                  "Name",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                content: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Hey, tell us you your name or how would you like to be called ;)",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                      child: StreamBuilder(
                          stream: _userBloc.name,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return TextField(
                              onChanged: _userBloc.changeName,
                              decoration: InputDecoration(
                                  filled: true,
                                  enabledBorder: InputBorder.none,
                                  errorText: snapshot.error,
                                  hintText: "Your Name",
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
                  ],
                ),
                isActive: true),
            new Step(
                // Title of the Step
                title: Text(
                  "About you",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                content: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Now, introduce a little bit about yourself. A good description can improve your visibility to other community members!!",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                    Container(
                      height: 150.0,
                      margin: EdgeInsets.only(bottom: 15.0),
                      padding: EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0, bottom: 15.0),
                      child: StreamBuilder(
                          stream: _userBloc.about,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return TextField(
                              onChanged: _userBloc.changeAbout,
                              keyboardType: TextInputType.multiline,
                              maxLines: 820,
                              decoration: InputDecoration(
                                  filled: true,
                                  errorText: snapshot.error,
                                  enabledBorder: InputBorder.none,
                                  hintText: "About you...",
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
                  ],
                ),
                isActive: true),
            Step(
                title: Text(
                  "Arrival in Japan",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "The date you arrived in japan",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 80.0,
                      padding: EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0, bottom: 15.0),
                      child: StreamBuilder(
                          stream: _userBloc.dateOfArrival,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return Row(
                              children: <Widget>[
                                Container(
                                  width: 70.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.blueGrey,
                                    elevation: 1.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        DateTime picked = await showDatePicker(
                                            context: context,
                                            initialDate: new DateTime.now(),
                                            firstDate: new DateTime(2016),
                                            lastDate: new DateTime(2020));
                                        if (picked != null) {
                                          _userBloc
                                              .changeDate(picked.toString());
                                          setState(() {
                                            this._datePicked =
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
                                Column(children: <Widget>[
                                  Container(
                                    width: 40.0,
                                    margin:
                                        EdgeInsets.only(top: 15.0, left: 10.0),
                                    child: Text(
                                      _datePicked.length >= 10
                                          ? _datePicked.substring(0, 10)
                                          : "", //_datePicked.substring(0, 10),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                  ),
                                ]),
                                Container(
                                  width: 150.0,
                                  child: Text(
                                    _datePicked.length <= 0
                                        ? "You must pick a date of arrival in Japan."
                                        : "",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
                isActive: true),
            Step(
                title: Text(
                  "Nationality",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Hey, where are you from?",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 80.0,
                      padding: EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0, bottom: 15.0),
                      child: StreamBuilder(
                          stream: _userBloc.nationality,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return CountryPicker(
                              dense: false,
                              showFlag: true, //displays flag, true by default
                              showDialingCode:
                                  false, //displays dialing code, false by default
                              showName:
                                  true, //displays country name, true by default
                              onChanged: (Country country) {
                                _userBloc.changeNationality(country.name);
                                setState(() {
                                  _selectedCountry = country;
                                });
                              },
                              selectedCountry: _selectedCountry,
                            );
                          }),
                    ),
                  ],
                ),
                isActive: true),

            Step(
                title: Text(
                  "Languages",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Please inform your spoken languages and level at each one.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                    Container(
                      child: StreamBuilder<Map<String, String>>(
                          stream: _userBloc.languages,
                          builder: (context,
                              AsyncSnapshot<Map<String, String>> snapshot) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  width: 80.0,
                                  height: 30.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.blueGrey,
                                    elevation: 1.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Theme(
                                              data: Theme.of(context).copyWith(
                                                  primaryColor: Colors.blue),
                                              child: LanguagePickerDialog(
                                                  titlePadding:
                                                      EdgeInsets.all(8.0),
                                                  searchCursorColor:
                                                      Colors.pinkAccent,
                                                  searchInputDecoration:
                                                      InputDecoration(
                                                          hintText:
                                                              'Search...'),
                                                  isSearchable: true,
                                                  title: Text(
                                                      'Select your language'),
                                                  onValuePicked:
                                                      (Language language) {
                                                    _userBloc.changeLanguage(
                                                        _languagesMap);
                                                    setState(() {
                                                      _languagesMap[language
                                                          .name] = "Basic";
                                                      print(
                                                          "ADDED NEW -- MAP: " +
                                                              _languagesMap
                                                                  .toString());
                                                    });
                                                  },
                                                  itemBuilder:
                                                      _buildDialogItem)),
                                        );
                                      },
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.all(0.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  child: Text(
                                    _languagesMap.isEmpty
                                        ? "You must pick at least one language."
                                        : "",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Column(
                                  children: languageWidget(),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
                isActive: true),

            Step(
                title: Text(
                  "Industry",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "What is your main area of work?",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                    StreamBuilder<String>(
                          stream: _userBloc.industry,
                          builder: (context,
                              AsyncSnapshot<String> snapshot) {
                            return
                              Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _selectedIndustry,
                                        items: _dropDownIndustryMenuItems,
                                        onChanged: (selectedIndustry) {
                                          _userBloc.changeIndustry(selectedIndustry);
                                          setState(() {
                                            _selectedIndustry = selectedIndustry;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );

                          }),
                  ],
                ),
                isActive: true),

          ],
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              currentStep = step;
            });
            debugPrint("onStepTapped: ${step.toString()}");
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep = currentStep - 1;
              } else {
                currentStep = 0;
              }
            });
            debugPrint("onStepCancel: " + currentStep.toString());
          },
          onStepContinue: () {
            setState(() {
              if (currentStep < numberOfSteps - 1) {
                currentStep = currentStep + 1;
              } else {
                currentStep = 0;
              }
            });
            debugPrint("onStepContinue: ${currentStep.toString()}");
          },
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: StreamBuilder(
            stream: _userBloc.submitStatus,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData || snapshot.hasError || !snapshot.data) {
                return Container(
                  height: 50.0,
                  width: 200.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(0.0),
                    color: Color(0xFF3498db),
                    elevation: 1.0,
                    child: GestureDetector(
                      onTap: () async {
                        debugPrint("Salvar tapped");
                        if (_userBloc.validateFields()) {
                          _userBloc.showProgressBar(true);
                          await _userBloc.createUserProfile();
                          _userBloc.showProgressBar(false);
                          Navigator.of(context).pop();
                        } else {
                          showErrorMessage("Invalid Form");
                        }
                      },
                      child: Center(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'Create',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    fontFamily: 'Montserrat'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
