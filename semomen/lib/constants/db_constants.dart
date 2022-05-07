import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final menteeRef = FirebaseFirestore.instance.collection('mentees');
final postRef = FirebaseFirestore.instance.collection('posts');
final adminRef = FirebaseFirestore.instance.collection('admin');
final mentorRef = FirebaseFirestore.instance.collection('mentors');
final groupChatRef = FirebaseFirestore.instance.collection('groupchat');
final mentoringRef = FirebaseFirestore.instance.collection('mentoring');
