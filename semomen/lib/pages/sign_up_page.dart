import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semomen/model/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ElevatedButton(onPressed: () {
              createUserData(users);
            }, child: Text('가입하기')),
          ],
        ),
      ),
    );
  }

  Future<void> createUserData(CollectionReference users) async{
    Map<String, dynamic> _userMap = UserModel(uid: '', userName: '', email: '', phoneNumber: '', birth: '', job: '').toJson();

    return await users.doc('1asfgh254tazsf').set(_userMap)
        .then((value) {
      print("User Added");
    })
        .catchError((error) => print("Failed to add user: $error"));
  }


}
