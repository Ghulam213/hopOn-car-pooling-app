class User {
  String? id;
  String username;
  String phoneNo;
  String token;
  String userType;

  User({
    this.id,
    required this.username,
    required this.phoneNo,
    required this.token,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      username: json['username'] as String,
      phoneNo: json['phoneNo'] as String,
      token: json['auth_token'] as String,
      userType: json['userType'] as String,
    );
  }
}
