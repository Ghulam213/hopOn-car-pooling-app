class UserData {
  String? id;
  String? coginitoId;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? locale;
  String? timezone;
  String? currentCity;
  String? gender;
  String? birthDate;
  String? profilePic;
  String? currentMode;
  String? createdAt;
  String? updatedAt;
  bool? optedInAt;
  bool? active;
  bool? verified;

  UserData({
    this.id,
    this.coginitoId,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.locale,
    this.timezone,
    this.currentCity,
    this.gender,
    this.birthDate,
    this.profilePic,
    this.optedInAt,
    this.active,
    this.verified,
    this.currentMode,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] as String?,
        coginitoId: json['coginitoId'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        locale: json['locale'] as String?,
        timezone: json['timezone'] as String?,
        currentCity: json['currentCity'] as String?,
        gender: json['gender'] as String?,
        birthDate: json['birthDate'] as String?,
        profilePic: json['profilePic'] as String?,
        optedInAt: json['optedInAt'] as bool?,
        active: json['active'] as bool?,
        verified: json['verified'] as bool?,
        currentMode: json['currentMode'] as String?,
        createdAt: json['currecreatedAtntMode'] as String?,
        updatedAt: json['updatedAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coginitoId": coginitoId,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "locale": locale,
        "timezone": timezone,
        "currentCity": currentCity,
        "gender": gender,
        "birthDate": birthDate,
        "profilePic": profilePic,
        "optedInAt": optedInAt,
        "active": active,
        "verified": verified,
        "currentMode": currentMode,
        "createdAt": createdAt,
        "updatedAt": updatedAt
      };
}
