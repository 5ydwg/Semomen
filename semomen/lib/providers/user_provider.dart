import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:semomen/constants/db_constants.dart';

class UserState {
  bool isLogin;
  bool isEmailValidated;

  UserState(this.isLogin, this.isEmailValidated);
}

class UserProvider extends ChangeNotifier {
  String _uid = FirebaseAuth.instance.currentUser!.uid;

  UserState userState = UserState(false, false);

  Stream<DocumentSnapshot> getCurrentUser() {
    return userRef.doc(_uid).snapshots();
  }

  void setUserState(isLogin, isEmailValidated) {
    userState.isLogin = isLogin;
    userState.isEmailValidated = isEmailValidated;
    notifyListeners();
  }
}
