class MentorModel{
  String uid;
  List<Map<String, dynamic>> menteeList;
  List<String> career;
  String introTitle;
  String intro;

  MentorModel({
    required this.uid,
    required this.menteeList,
    required this.career,
    required this.introTitle,
    required this.intro,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'mentee_list':menteeList,
    'career':career,
    'intro_title':introTitle,
    'intro':intro,
  };

  MentorModel.fromJson(Map<String, dynamic> json) :
        uid = json['uid'] ?? '',
        menteeList = json['mentee_list'] ?? [],
        career = json['career'] ?? [],
        introTitle = json['intro_title'] ?? '',
        intro = json['intro'] ?? '';
}