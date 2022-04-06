import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final menteeRef = FirebaseFirestore.instance.collection('mentees');