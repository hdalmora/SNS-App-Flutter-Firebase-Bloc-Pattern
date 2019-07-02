import 'dart:async';
import 'package:buddies_osaka/src/utils/Strings.dart';
import 'package:buddies_osaka/src/utils/Validator.dart';
import 'package:buddies_osaka/src/resources/Repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationBloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _displayName = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Observable<String> get email =>
      _email.stream.transform(_validateEmail);

  Observable<String> get displayName => _displayName.stream.transform(_validateDisplayName);

  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  Observable<bool> get signInStatus => _isSignedIn.stream;

  String get emailAddress => _email.value;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changeDisplayName => _displayName.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateDisplayName =
  StreamTransformer<String, String>.fromHandlers(handleData: (displayName, sink) {
    if (displayName.length > 5) {
      sink.add(displayName);
    } else {
      sink.addError("Display name must be at least 6 characters.");
    }
  });

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validator.validateEmail(email)) {
      sink.add(email);
    } else {
      sink.addError(StringConstant.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (Validator.validatePassword(password)) {
      sink.add(password);
    } else {
      sink.addError(StringConstant.passwordValidateMessage);
    }
  });

  Stream<FirebaseUser> onUserAuthChange() => _repository.getUserOnAuthState();

  Future<void> signInUserAnonymously() {
    return _repository.signInAnonymously();
  }

  Future<int> signInUser() {
    return _repository.signInWithEmailAndPassword(
        _email.value, _password.value);
  }

  Future<int> registerUser() {
    return _repository.signUpWithEmailAndPassword(
        _email.value, _password.value, _displayName.value);
  }

  Future<FirebaseUser> getCurrentUser() => _repository.getCurrentUser();

  Future<int> sendEmailConfirmation() => _repository.sendEmailConfirmation();

  Future<void> authenticateWithGoogle() => _repository.signInWithGoogle();

  Future<void> signOut() => _repository.signOut();

  void dispose() async {
    await _email.drain();
    _email.close();
    await _displayName.drain();
    _displayName.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _email.value.contains("@") &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 5) {
      return true;
    } else {
      return false;
    }
  }

  bool validateAllFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _email.value.contains("@") &&
        _displayName.value != null &&
        _displayName.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 5) {
      return true;
    } else {
      return false;
    }
  }
}
