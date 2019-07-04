import 'dart:async';
import 'package:buddies_osaka/src/utils/Strings.dart';
import 'package:buddies_osaka/src/utils/Validator.dart';
import 'package:buddies_osaka/src/resources/Repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class BlogBloc {
  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _content = BehaviorSubject<String>();

  final _comment = BehaviorSubject<String>();

  final _isSubmitted = BehaviorSubject<bool>();
  final _userHasPermission = BehaviorSubject<bool>();

  Observable<String> get title => _title.stream.transform(_validateTitle);

  Observable<String> get content => _content.stream.transform(_validateContent);

  Observable<String> get comment => _comment.stream.transform(_validateComment);

  Observable<bool> get userHasPermission => _userHasPermission.stream;

  Observable<bool> get submissionStatus => _isSubmitted.stream;

  // Change data
  Function(String) get changeTitle => _title.sink.add;

  Function(String) get changeContent => _content.sink.add;

  Function(String) get changeComment => _comment.sink.add;

  Function(bool) get setUserPermission => _userHasPermission.sink.add;

  Function(bool) get showProgressBar => _isSubmitted.sink.add;

  final _validateTitle =
  StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title.length > 11) {
      sink.add(title);
    } else {
      sink.addError("Title must have at least 12 characters");
    }
  });

  final _validateContent = StreamTransformer<String, String>.fromHandlers(
      handleData: (content, sink) {
        if (content.length > 49) {
          sink.add(content);
        } else {
          sink.addError("Content must have at least " + content.length.toString() + "/50 characters");
        }
      });

  final _validateComment = StreamTransformer<String, String>.fromHandlers(
      handleData: (content, sink) {
        if (content.length > 14) {
          sink.add(content);
        } else {
          sink.addError("Comment must have at least " + content.length.toString() + "/15 characters");
        }
      });

  void dispose() async {
    await _title.drain();
    _title.close();
    await _content.drain();
    _content.close();
    await _comment.drain();
    _comment.close();
    await _userHasPermission.drain();
    _userHasPermission.close();
    await _isSubmitted.drain();
    _isSubmitted.close();
  }

  bool validateFields() {
    if (_title.value != null &&
        _title.value.isNotEmpty &&
        _title.value.length > 11 &&
        _content.value != null &&
        _content.value.isNotEmpty &&
        _content.value.length > 49) {
      return true;
    } else {
      return false;
    }
  }

  bool validateComment() {
    if(_comment.value != null &&
       _comment.value.isNotEmpty &&
       _comment.value.length > 14) {
      return true;
    }
    return false;
  }

  Future<String> getUserUID() async {
    FirebaseUser user = await _repository.getUserAuth();
    return user.uid;
  }

  Future<String> getUserDisplayNAme() async {
    FirebaseUser user = await _repository.getUserAuth();
    return user.providerData[0].displayName;
  }

  Future<String> getUserEmail() async {
    FirebaseUser user = await _repository.getUserAuth();
    return user.email;
  }
  Future<void> submit() async {
      _isSubmitted.sink.add(true);
      String uid = await getUserUID();
      String email = await getUserEmail();

      await _repository.postBlog(uid, email, _title.value, _content.value);
      _isSubmitted.sink.add(false);
  }

  Future<bool> userAccessPermission(bool profileCreated) async {
    FirebaseUser user = await _repository.getCurrentUser();

    if(user.isAnonymous || !user.isEmailVerified || !profileCreated)
      return false;
    return true;
  }

  Future<void> postComment(String blogUID) async {
    _isSubmitted.sink.add(true);
    String userUID = await getUserUID();
    String userEmail = await getUserEmail();
    String userDisplayName = await getUserDisplayNAme();

    await _repository.postUserCommentToBlog(userUID, blogUID, userEmail, userDisplayName, _comment.value);
    _isSubmitted.sink.add(false);
  }

  Stream<QuerySnapshot> commentsList(int limit, String blogUID) => _repository.commentsList(limit, blogUID);

  Stream<QuerySnapshot> blogsList(int limit) => _repository.blogsList(limit);

  Future<QuerySnapshot> fetchBlogs(int limit) => _repository.fetchBlogs(limit);

  Future<QuerySnapshot> fetchBlogsFromLastDocument(int limit, DocumentSnapshot lastDoc) =>
      _repository.fetchBlogsFromLastDocument(limit, lastDoc);

  Future<void> likeBlogPost(String blogUID) async {
    String uid = await getUserUID();

    await _repository.likeBlogPost(blogUID, uid);
  }

  Future<void> unlikeBlogPost(String blogUID) async {
    String uid = await getUserUID();

    await _repository.unlikeBlogPost(blogUID, uid);
  }

  Future<bool> hasLikedBlog(String blogUID) async {
    String uid = await getUserUID();

    return _repository.hasLikedBlog(blogUID, uid);
  }
}
