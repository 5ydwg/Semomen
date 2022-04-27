class MenteeModel {
  String uid;
  List<dynamic> mentor;
  List<dynamic> programId;
  List<dynamic> couponList;
  List<dynamic> recentlyViewedPosts;

  MenteeModel({
    required this.uid,
    required this.mentor,
    required this.programId,
    required this.couponList,
    required this.recentlyViewedPosts,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'mentor': mentor,
        'program_id': programId,
        'coupon_list': couponList,
        'recently_viewed_posts': recentlyViewedPosts,
      };

  MenteeModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        mentor = json['mentor_uid'] ?? [],
        programId = json['program_id'] ?? [],
        couponList = json['coupon_list'] ?? [],
        recentlyViewedPosts = json['recently_viewed_posts'] ?? [];
}
