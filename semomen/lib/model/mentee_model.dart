class MenteeModel{
  String uid;
  List<String> mentorUid;
  List<String> programId;
  List<String> couponList;

  MenteeModel({
    required this.uid,
    required this.mentorUid,
    required this.programId,
    required this.couponList,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'mentor_uid':mentorUid,
    'program_id':programId,
    'coupon_list':couponList,
  };

  MenteeModel.fromJson(Map<String, dynamic> json) :
        uid = json['uid'] ?? '',
        mentorUid = json['mentor_uid'] ?? [],
        programId = json['program_id'] ?? [],
        couponList = json['coupon_list'] ?? [];
}