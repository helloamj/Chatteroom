class UserModel {
  static UserModel? mainuserModel;
  String? phonenumber;
  String? fullname;
  String? bio;
  String? profilepic;
  UserModel({this.phonenumber, this.fullname, this.bio, this.profilepic});

  UserModel.fromMap(Map<String, dynamic> mp) {
    phonenumber = mp['phonenumber'];
    fullname = mp['fullname'];
    bio = mp['bio'];
    profilepic = mp['profilepic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'phonenumber': phonenumber,
      'fullname': fullname,
      'bio': bio,
      'profilepic': profilepic,
    };
  }
}
