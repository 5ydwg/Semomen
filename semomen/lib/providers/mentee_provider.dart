import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:semomen/model/mentee_model.dart';

import '../constants/db_constants.dart';

class MenteeProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;

  MenteeProvider({
    required this.firebaseAuth,
  });

  Future<DocumentSnapshot> getMentee() async {
    final DocumentSnapshot snapshot =
        await menteeRef.doc(firebaseAuth.currentUser!.uid).get();
    return snapshot;
  }

  Future<bool> existMyMentor(uid) async {
    final DocumentSnapshot menteeDoc =
        await menteeRef.doc(firebaseAuth.currentUser!.uid).get();
    final menteeData = menteeDoc.data() as Map<String, dynamic>?;
    List my_mentor = menteeData!['mentor_uid'];
    print(my_mentor);

    return false;
  }
}
