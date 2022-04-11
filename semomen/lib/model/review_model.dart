import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String profileImg;
  String review;
  int star;
  String uid;
  DateTime uploadTime;
  String userName;

  ReviewModel({
    required this.profileImg,
    required this.review,
    required this.star,
    required this.uid,
    required this.uploadTime,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
    'profile_img':profileImg,
    'review':review,
    'star':star,
    'uid':uid,
    'upload_time':uploadTime,
    'user_name':userName,
  };

  factory ReviewModel.fromDoc(DocumentSnapshot reviewDoc) {
    final reviewData = reviewDoc.data() as Map<String, dynamic>?;
    return ReviewModel(
        profileImg : reviewData!['profile_img'] ?? '',
        review : reviewData['review'],
        star : reviewData['star'],
        uid: reviewData['uid'],
        uploadTime : reviewData['upload_time'].toDate(),
        userName : reviewData['user_name'],
    );
  }

}