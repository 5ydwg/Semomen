import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  String postId;
  String uid;
  List<dynamic> career;
  DateTime dateTime;
  //Map<String, dynamic> guides;
  List<dynamic> lecture;
  List<dynamic> major;
  List<dynamic> vLog;
  //List<dynamic>? youtube;
  String intro;
  String introTitle;
  String job;
  String jobDesc;
  String jobImgUrl;
  String jobVideoUrl;
  String profileImg;
  String userName;
  String isActivate;
  bool isMentoring;


  PostModel({
    required this.postId,
    required this.uid,
    required this.career,
    required this.dateTime,
    //required this.guides,
    required this.lecture,
    required this.major,
    required this.vLog,
    //this.youtube,
    required this.intro,
    required this.introTitle,
    required this.job,
    required this.jobDesc,
    required this.jobImgUrl,
    required this.jobVideoUrl,
    required this.profileImg,
    required this.userName,
    required this.isActivate,
    required this.isMentoring,
  });

  factory PostModel.fromDoc(DocumentSnapshot postDoc) {
    final postData = postDoc.data() as Map<String, dynamic>?;

    return PostModel(
      postId: postDoc.id,
      uid: postData!['uid'],
      career : postData['career'],
      //dateTime : postData['upload_time'].toDate() ?? DateTime.now(),
      dateTime : postData['date_time'].toDate() ?? DateTime.now(),
      lecture : postData['guides']['lecture'] ?? [],
      major : postData['guides']['major'] ?? [],
      vLog : postData['guides']['v_log'] ?? [],
      //youtube: postData['guides']['you_tube'] ?? [],
      intro : postData['intro'] ?? '',
      introTitle : postData['intro_title'] ?? '',
      job : postData['job'] ?? '',
      jobDesc : postData['job_desc'] ?? '',
      jobImgUrl : postData['job_img_url']  ?? '',
      jobVideoUrl : postData['job_video_url'] ?? '',
      profileImg : postData['profile_img'] ?? '',
      userName : postData['user_name'] ?? '',
      isActivate: postData['is_activate'] ?? '',
      isMentoring: postData['is_mentoring'] ?? false,
    );
  }

}

