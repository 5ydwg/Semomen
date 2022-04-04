class MentorModel{
  String uid;
  List<String> menteeUid;
  List<String> career;
  String introTitle;
  String intro;

  MentorModel({
    required this.uid,
    required this.menteeUid,
    required this.career,
    required this.introTitle,
    required this.intro,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'mentee_uid':menteeUid,
    'career':career,
    'intro_title':introTitle,
    'intro':intro,
  };

  MentorModel.fromJson(Map<String, dynamic> json) :
        uid = json['uid'] ?? '',
        menteeUid = json['mentee_uid'] ?? [],
        career = json['career'] ?? [],
        introTitle = json['intro_title'] ?? '',
        intro = json['intro'] ?? '';
}