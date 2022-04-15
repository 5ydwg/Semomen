class MenteeModel{
  String uid;
  List<dynamic> mentorUid;
  List<dynamic> programId;
  List<dynamic> couponList;
  List<dynamic> recentlyViewedPosts;

  MenteeModel({
    required this.uid,
    required this.mentorUid,
    required this.programId,
    required this.couponList,
    required this.recentlyViewedPosts,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'mentor_uid':mentorUid,
    'program_id':programId,
    'coupon_list':couponList,
    'recently_viewed_post':recentlyViewedPosts,
  };

  MenteeModel.fromJson(Map<String, dynamic> json) :
        uid = json['uid'] ?? '',
        mentorUid = json['mentor_uid'] ?? [],
        programId = json['program_id'] ?? [],
        couponList = json['coupon_list'] ?? [],
        recentlyViewedPosts = json['recently_viewed_post'] ?? [];
}