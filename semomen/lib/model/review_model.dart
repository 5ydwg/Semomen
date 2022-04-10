import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String review;
  int star;
  String uid;
  DateTime uploadTime;

  ReviewModel({
    required this.review,
    required this.star,
    required this.uid,
    required this.uploadTime,
  });

  Map<String, dynamic> toJson() => {
    'review':review,
    'star':star,
    'uid':uid,
    'upload_time':uploadTime,
  };

  factory ReviewModel.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;
    return ReviewModel(
        review : userData!['review'],
        star : userData['star'],
        uid: userDoc.id,
        uploadTime : userData['upload_time'].toDate(),
    );
  }

}