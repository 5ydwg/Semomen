import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String uid;
  String userName;
  String birth;
  bool isMentor;
  bool isMentee;
  String profileImg;
  String job;
  String email;
  String phoneNumber;

  UserModel({
    required this.uid,
    required this.userName,
    required this.birth,
    required this.isMentor,
    required this.isMentee,
    required this.email,
    required this.profileImg,
    required this.job,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'user_name':userName,
    'birth':birth,
    'is_mentor':isMentor,
    'is_mentee':isMentee,
    'profile_img':profileImg,
    'job':job,
    'email':email,
    'phone_number':phoneNumber,
  };

  factory UserModel.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;
    return UserModel(
      uid: userDoc.id,
      userName : userData!['user_name'],
      birth : userData['birth'],
      isMentor : userData['is_mentor'],
      isMentee : userData['is_mentee'],
      profileImg : userData['profile_img'],
      job : userData['job'],
      email : userData['email'],
      phoneNumber : userData['phone_number'],
    );
  }

  factory UserModel.initial() {
    return UserModel(
      uid: '',
      userName : '',
      birth : '',
      isMentor : false,
      isMentee : false,
      profileImg : '',
      job : '',
      email : '',
      phoneNumber : '',
    );
  }
}

