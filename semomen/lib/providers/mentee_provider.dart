import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/db_constants.dart';

class MenteeProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  MenteeProvider({
    required this.firebaseAuth,
  });

  Future<DocumentSnapshot> getMentee() async {
    final DocumentSnapshot snapshot = await menteeRef.doc(firebaseAuth.currentUser!.uid).get();
    return snapshot;
  }
}