class SocialUserModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  SocialUserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.cover,
    required this.bio,
    required this.isEmailVerified,
  });

  SocialUserModel.fromJson(Map<String, dynamic> json) {
    uId = json["uId"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    image = json["image"];
    cover = json["cover"];
    bio = json["bio"];
    isEmailVerified = json["isEmailVerified"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uId": uId,
      "name": name,
      "email": email,
      "phone": phone,
      "image": image,
      "cover": cover,
      "bio": bio,
      "isEmailVerified": isEmailVerified,
    };
  }
}
