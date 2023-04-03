import 'package:hop_on/core/registration/models/vehicle.dart';

import '../../auth/models/user.dart';

class Driver {
  final String? id;
  final String? cnicFront;
  final String? cnicBack;
  final String? licenseFront;
  final String? licenseBack;
  final String? userId;
  final bool? verified;
  final bool? active;
  final User? user;
  final List<Vehicle>? vehicles;

  Driver({
    this.id,
    this.cnicFront,
    this.cnicBack,
    this.licenseFront,
    this.licenseBack,
    this.userId,
    this.verified,
    this.active,
    this.user,
    this.vehicles,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String?,
      cnicFront: json['cnicFront'] as String?,
      cnicBack: json['cnicBack'] as String?,
      licenseFront: json['licenseFront'] as String?,
      licenseBack: json['licenseBack'] as String?,
      userId: json['userId'] as String?,
      verified: json['verified'] as bool?,
      active: json['active'] as bool?,
      vehicles: (json['data'] as List<dynamic>?)
          ?.map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "cnicFront": cnicFront,
        "cnicBack": cnicBack,
        "licenseFront": licenseFront,
        "licenseBack": licenseBack,
        "userId": userId,
        "verified": verified,
        "active": active,
        'data': vehicles?.map((e) => e.toJson()).toList(),
        'user': user?.toJson(),
      };
}
