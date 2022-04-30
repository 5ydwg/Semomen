import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/db_constants.dart';
import '../../model/user_model.dart';

class ProfileClick extends StatefulWidget {
  const ProfileClick({Key? key}) : super(key: key);

  @override
  State<ProfileClick> createState() => _ProfileClickState();
}

class _ProfileClickState extends State<ProfileClick> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference mentees =
      FirebaseFirestore.instance.collection('mentees');
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: userRef.doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          UserModel _user = UserModel.fromDoc(snapshot.data!);
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Container(
                width: double.infinity,
                height: size.width * 1.7,
                child: Image.network(
                  _user.profileImg == 'undefined'
                      ? 'https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_1280.png'
                      : _user.profileImg,
                  fit: BoxFit.cover,
                )),
          );
        }
      },
    );
  }
}
