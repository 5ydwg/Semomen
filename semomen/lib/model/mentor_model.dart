class MentorModel{
  String uid;
  List<Map<String, dynamic>> menteeList;
  List<String> career;


  MentorModel({
    required this.uid,
    required this.menteeList,
    required this.career,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'mentee_list':menteeList,
    'career':career,
  };

  MentorModel.fromJson(Map<String, dynamic> json) :
        uid = json['uid'] ?? '',
        menteeList = json['mentee_list'] ?? [],
        career = json['career'] ?? [];
}