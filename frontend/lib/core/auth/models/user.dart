class User {
  int? id;
  String? userType;
  String? phone;
  String? status;
  int? userId;
  String? email;
  String? loginType;
  String? locale;
  String? authToken;
  User? user;

  User(this.id, this.userType, this.phone, this.status, this.userId, this.email,
      this.loginType, this.locale, this.authToken, this.user);

  factory User.fromJson(dynamic json) {
    return User(
      json['id'] as int?,
      json['userType'] as String?,
      json['phone'] as String?,
      json['status'] as String?,
      json['userId'] as int?,
      json['email'] as String?,
      json['loginType'] as String?,
      json['locale'] as String?,
      json['authToken'] as String?,
      json['user'] == null
          ? null
          : User.fromJson(json['menu_item'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userType': userType,
        'phone': phone,
        'status': status,
        'userId': userId,
        'email': email,
        'loginType': loginType,
        'locale': locale,
        'authToken': authToken,
        'user': user,
      };
}


// "user": {
//     "id": "string",
//     "coginitoId": "string",
//     "email": "string",
//     "firstName": "string",
//     "lastName": "string",
//     "phone": "string",
//     "locale": "string",
//     "timezone": "string",
//     "currentCity": "string",
//     "gender": "MALE",
//     "birthDate": "2023-03-31T11:09:35.484Z",
//     "profilePic": "string",
//     "optedInAt": true,
//     "active": true,
//     "verified": true,
//     "currentMode": "DRIVER",
//     "createdAt": "2023-03-31T11:09:35.484Z",
//     "updatedAt": "2023-03-31T11:09:35.484Z"
//   },