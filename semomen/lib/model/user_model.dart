class UserModel{
  String uid;
  String userName;
  String birth;
  bool isMentor = false;
  bool isMentee = true;
  String profileImg = '';
  String job;
  String email;
  String phoneNumber;

  UserModel({
    required this.uid,
    required this.userName,
    required this.birth,
    required this.email,
    required this.job,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'user_name':userName,
    'birth':birth,
    'is_mentor':isMentor,
    'is_mentee':isMentee,
    'profile_img':profileImg,
    'job':job,
    'email':email,
    'phone_number':phoneNumber,
  };

  UserModel.fromJson(Map<String, dynamic> json) :
  uid = json['uid'] ?? '',
  userName = json['user_name'] ?? '',
  birth = json['birth'] ?? '',
  isMentor = json['is_mentor'] ?? '',
  isMentee = json['is_mentee'] ?? '',
  profileImg = json['profile_img'] ?? '',
  job = json['job'] ?? '',
  email = json['email'] ?? '',
  phoneNumber = json['phone_number'] ?? '';

}

