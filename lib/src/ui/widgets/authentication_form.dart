import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/components/button-main-text-icon.dart';
import 'package:buddies_osaka/src/components/input-text-main.dart';
import 'package:flutter/services.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBloc.dart';
import 'package:buddies_osaka/src/blocs/authentication/AuthenticationBlocProvider.dart';
import 'package:buddies_osaka/src/utils/Strings.dart';

class AuthenticationForm extends StatefulWidget {
  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  AuthenticationBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthenticationBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        StreamBuilder(
            stream: _authBloc.email,
            builder: (context, snapshot) {
              return InputTextMain(
                hintText: StringConstant.emailHint,
                errorText: snapshot.error,
                onChanged: _authBloc.changeEmail,
                textType: TextInputType.emailAddress,
                height: 60.0,
              );
            }),
        SizedBox(height: 10.0),
        StreamBuilder(
            stream: _authBloc.password,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return InputTextMain(
                hintText: StringConstant.passwordHint,
                height: 60.0,
                textType: TextInputType.text,
                onChanged: _authBloc.changePassword,
                errorText: snapshot.error,
                password: true,
              );
            }),
      ],
    );
  }

  Widget authenticationButtonsController() {
    return StreamBuilder(
        stream: _authBloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError || !snapshot.data) {
            return buttonsArea();
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          }
        });
  }

  Widget buttonsArea() {
    return Container(
      padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          forgotPasswordButton(),
          SizedBox(height: 25.0),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                signInButton(),
                registerButton(),
              ],
            ),
          ),
          SizedBox(height: 50.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                googleSignInbutton(),
                skipButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPasswordButton() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(left: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          "Forgot password?",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 17.0,
              fontFamily: 'Montserrat'),
        ),
      ),
    );
  }

  Widget skipButton() {
    return Container(
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () async {
            _authBloc.showProgressBar(true);
           await  _authBloc.signInUserAnonymously();
           _authBloc.showProgressBar(false);
          },
          child: Text(
            "Skip  >",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Montserrat'),
          ),
        ),
      ),
    );
  }

  Widget googleSignInbutton() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(right: 20.0),
      child: Builder(
        builder: (context) => Container(
            height: 45.0,
            child: ButtonMainTextIcon(
              callback: () async {
                //TODO: Insert google SignIn in Auth Bloc
              },
              bgColor: Colors.white,
              width: 170.0,
              paddingLeft: 0.0,
              imageSize: 25.0,
              paddingRight: 0.0,
              iconImagePath: 'assets/images/google_logo_g_transparent.png',
              text: "Sign In",
              textColor: Color(0xFF5D7EB6),
              spaceBetweenImageAndText: 10.0,
            )),
      ),
    );
  }

  Widget registerButton() {
    return Container(
        height: 45.0,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: ButtonMainTextIcon(
          callback: () async {
            if (_authBloc.validateFields()) {
              registerUser();
            } else {
              showErrorMessage("Invalid Login Form");
            }
          },
          bgColor: Colors.white,
          paddingLeft: 0.0,
          paddingRight: 0.0,
          width: 120.0,
          text: "Register",
          textColor: Color(0xFF5D7EB6),
        ));
  }

  Widget signInButton() {
    return Container(
        height: 45.0,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: ButtonMainTextIcon(
          callback: () async {
            if (_authBloc.validateFields()) {
              signInUser();
            } else {
              showErrorMessage("Invalid Login Form");
            }
          },
          bgColor: Colors.white,
          paddingLeft: 0.0,
          paddingRight: 0.0,
          width: 120.0,
          text: "Sign In",
          textColor: Color(0xFF5D7EB6),
        ));
  }

  void showErrorMessage(String message) {
    final snackbar =
        SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void signInUser() async {
    _authBloc.showProgressBar(true);

    int response = await _authBloc.signInUser();

    _authBloc.showProgressBar(false);
    if (response < 0) {
      showErrorMessage("Email and/or Password are incorrect.");
    }
  }

  void registerUser() async {
    _authBloc.showProgressBar(true);

    int response = await _authBloc.registerUser();

    _authBloc.showProgressBar(false);
    if (response < 0) {
      showErrorMessage(
          "Could not register user. Maybe e-mail is already been taken");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF204D9E),
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 25.0, 0.0, 0.0),
                alignment: Alignment.topLeft,
                child: Text('beta v0.0.1',
                    style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 150.0,
                margin: EdgeInsets.only(top: 30.0),
                alignment: Alignment.center,
                child: Image.asset('assets/images/b_logo_b.png',
                    fit: BoxFit.cover),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: formUI(),
                    ),
                    SizedBox(height: 3.0),
                  ],
                ),
              ),
              authenticationButtonsController(),
            ],
          ),
        ],
      ),
    );
  }
}
