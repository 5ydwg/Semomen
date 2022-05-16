import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:semomen/constants/db_constants.dart';


class UserProvider extends ChangeNotifier {
  String _uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<DocumentSnapshot> getCurrentUser() {
    return userRef.doc(_uid).snapshots();
  }

}
