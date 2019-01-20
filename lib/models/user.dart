import 'model.dart';

class UserForm implements Model {
  String username;
  String email;
  String password;
  DateTime dateTime;
  String thumbnailUrl;
}

class User implements Model {
  final String username;
  final String email;
  final String password;
  final String thumbnailUrl;
  final String uid;
  final String providerId;
  final String mobile;

  User(
      {this.username,
      this.email,
      this.password,
      this.thumbnailUrl,
      this.uid,
      this.providerId,
      this.mobile});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        username: json['displayName'] ?? json["username"],
        email: json['email'],
        password: json['password'],
        thumbnailUrl: json['thumbnailUrl'] ?? json['photoUrl'],
        uid: json['uid'],
        providerId: json['providerId'],
        mobile: json['mobile']);
  }
  toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "thumbnailUrl": thumbnailUrl,
      "uid": uid,
      "providerId": providerId,
      "mobile": mobile
    };
  }
}
