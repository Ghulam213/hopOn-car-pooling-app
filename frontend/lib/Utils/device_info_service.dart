import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

mixin DeviceInfoService {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future<DeviceInformation?> getDeviceInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final DeviceInformation deviceInformation = DeviceInformation(
          androidInfo.id,
          "Android",
          androidInfo.brand,
          androidInfo.model,
          androidInfo.version.release,
          androidInfo.isPhysicalDevice,
          androidInfo.tags,
          packageInfo.version,
          packageInfo.buildNumber);

      return deviceInformation;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      final DeviceInformation deviceInformation = DeviceInformation(
          iosInfo.identifierForVendor,
          "IOS",
          iosInfo.name,
          iosInfo.model,
          iosInfo.systemVersion,
          iosInfo.isPhysicalDevice,
          '',
          packageInfo.version,
          packageInfo.buildNumber);

      return deviceInformation;
    } else {
      return null;
    }
  }
}

class DeviceInformation {
  String? uUID;
  String? os;
  String? brand;
  String? model;
  String? osVersion;
  bool? isPhysical;
  String? tags;
  String? appVer;
  String? appBuild;

  DeviceInformation(this.uUID, this.os, this.brand, this.model, this.osVersion,
      this.isPhysical, this.tags, this.appVer, this.appBuild);

  factory DeviceInformation.fromJson(dynamic json) {
    return DeviceInformation(
      json['uUID'] as String?,
      json['os'] as String?,
      json['brand'] as String?,
      json['model'] as String?,
      json['osVersion'] as String?,
      json['isPhysical'] as bool?,
      json['tags'] as String?,
      json['appVer'] as String?,
      json['appBuild'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'uUID': uUID,
        'os': os,
        'brand': brand,
        'model': model,
        'osVersion': osVersion,
        'isPhysical': isPhysical,
        'tags': tags,
        'appVer': appVer,
        'appBuild': appBuild
      };
}
