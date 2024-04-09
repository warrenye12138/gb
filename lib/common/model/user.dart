import 'dart:convert';

class UserEntity {
  String? uid;
  String? avatar;
  String? name;
  String? email;
  String? password;
  String? identity;

  UserEntity(
      {this.uid,
      this.avatar,
      this.name,
      this.email,
      this.password,
      this.identity});
  factory UserEntity.fromJson(Map<dynamic, dynamic> json) {
    return UserEntity(
        uid: json['uid'],
        avatar: json['avatar'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        identity: json['identity']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'avatar': avatar,
        'name': name,
        'email': email,
        'password': password,
        'identity': identity,
      };

  @override
  String toString() {
    return jsonEncode(this);
  }
}
