import 'package:buddies_osaka/src/resources/Repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


class UserBloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _about = BehaviorSubject<String>();
  final _nationality = BehaviorSubject<String>();
  final _dateOfArrival = BehaviorSubject<String>();
  final _industry = BehaviorSubject<String>();
  final _languages = BehaviorSubject<Map<String, String>>();
  final _isSubmitted = BehaviorSubject<bool>();

  Observable<String> get name => _name.stream.transform(_validateName);

  Observable<String> get about => _about.stream.transform(_validateAbout);

  Observable<String> get nationality => _nationality.stream.transform(_validateAbout);

  Observable<String> get dateOfArrival => _dateOfArrival.stream.transform(_validateDate);

  Observable<String> get industry => _industry.stream.transform(_validateIndustry);

  Observable<Map<String, String>> get languages => _languages.stream.transform(_validateLanguages);

  final _validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 5) {
      sink.add(name);
    } else {
      sink.addError("Name must be at least 6 characters.");
    }
  });

  final _validateAbout =
      StreamTransformer<String, String>.fromHandlers(handleData: (about, sink) {
    if (about.length > 11) {
      sink.add(about);
    } else {
      sink.addError("About must be at least 12 characters.");
    }
  });

  final _validateDate =
      StreamTransformer<String, String>.fromHandlers(handleData: (date, sink) {
    if (date.length > 9) {
      sink.add(date);
    } else {
      sink.addError("You must pick a date of arrival in Japan.");
    }
  });

  final _validateLanguages =
      StreamTransformer<Map<String, String>, Map<String, String>>.fromHandlers(
          handleData: (languages, sink) {
    if (languages.isNotEmpty) {
      sink.add(languages);
    } else {
      sink.addError("You must pick at least one language.");
    }
  });

  final _validateIndustry =
  StreamTransformer<String, String>.fromHandlers(
      handleData: (industry, sink) {
        if (industry.isNotEmpty) {
          sink.add(industry);
        } else {
          sink.addError("You must pick at least one Industry.");
        }
      });

  Observable<bool> get submitStatus => _isSubmitted.stream;

  // Change data
  Function(String) get changeName => _name.sink.add;

  Function(String) get changeAbout => _about.sink.add;

  Function(String) get changeNationality => _nationality.sink.add;

  Function(String) get changeDate => _dateOfArrival.sink.add;

  Function(String) get changeIndustry => _industry.sink.add;

  Function(Map<String, String>) get changeLanguage => _languages.sink.add;

  Function(bool) get showProgressBar => _isSubmitted.sink.add;

  Future<void> createUserProfile() async {
    FirebaseUser user = await _repository.getUserAuth();
    _repository.createUserProfile(user.uid, user.email, _name.value, _about.value, _dateOfArrival.value, _nationality.value, _languages.value, _industry.value);
  }

  Future<bool> isAnonym() async {
    FirebaseUser user = await _repository.getUserAuth();
    return user.isAnonymous;
  }

  Future<String> getUserUID() async {
    FirebaseUser user = await _repository.getUserAuth();
    return user.uid;
  }

  Stream<DocumentSnapshot> getUserData(String documentID) => _repository.getUserData(documentID);

  void dispose() async {
    await _name.drain();
    _name.close();
    await _about.drain();
    _about.close();
    await _dateOfArrival.drain();
    _dateOfArrival.close();
    await _nationality.drain();
    _nationality.close();
    await _languages.drain();
    _languages.close();
    await _industry.drain();
    _industry.close();
    await _isSubmitted.drain();
    _isSubmitted.close();
  }

  bool validateFields() {
    if (_name.value != null &&
        _name.value.isNotEmpty &&
        _about.value != null &&
        _about.value.isNotEmpty &&
        _dateOfArrival.value != null &&
        _dateOfArrival.value.isNotEmpty &&
        _name.value.length > 5 &&
        _about.value.length > 11 &&
        _dateOfArrival.value.length > 9 &&
        _languages.value.isNotEmpty &&
        _industry.value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
