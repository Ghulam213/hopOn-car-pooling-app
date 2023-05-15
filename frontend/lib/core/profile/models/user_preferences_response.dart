class PassengerPrefsResponse {
  PassengerPrefs? data;

  PassengerPrefsResponse({this.data});

  factory PassengerPrefsResponse.fromJson(Map<String, dynamic> json) {
    return PassengerPrefsResponse(
      data: json['data'] == null
          ? null
          : PassengerPrefs.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PassengerPrefs {
  final String? id;
  final String? passengerId;
  final String? genderPreference;

  PassengerPrefs({this.id, this.passengerId, this.genderPreference});

  factory PassengerPrefs.fromJson(Map<String, dynamic> json) {
    return PassengerPrefs(
      id: json['id'] as String?,
      passengerId: json['passengerId'] as String?,
      genderPreference: json['genderPreference'] as String?,
    );
  }
}
