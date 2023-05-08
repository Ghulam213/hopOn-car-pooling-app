// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/config/network/network_config.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/screens/auth_screen.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:hop_on/core/notifications/widgets/with_notificatons.dart';
import 'package:hop_on/core/registration/viewmodel/registration_viewmodel.dart';
import 'package:hop_on/firebase_options.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/device_info_service.dart';
import 'Utils/styles.dart';
import 'core/map/viewmodel/map_view_model.dart';
import 'core/profile/viewmodel/profile_viewmodel.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  NetworkConfig().initNetworkConfig();
  await _initLocationService();
  await _getDeviceInfo();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', ''), Locale('de', '')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', ''),
      child: const App(),
    ),
  );
}

Future _getDeviceInfo() async {
  final prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  final DeviceInformation? deviceInformation =
      await DeviceInfoService.getDeviceInfo();
  prefs.setString("deviceId", deviceInformation?.uUID.toString() ?? '');
  prefs.setString("deviceInfo", deviceInformation?.toJson().toString() ?? '');
}

Future _initLocationService() async {
  var location = loc.Location();

  if (!await location.serviceEnabled()) {
    if (!await location.requestService()) {
      return;
    }
  }

  var permission = await location.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await location.requestPermission();
    if (permission != PermissionStatus.granted) {
      return;
    }
  }

  var locationService = await location.getLocation();
  debugPrint("${locationService.latitude} ${locationService.longitude}");
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: AppColors.PRIMARY_500,
      ),
    );

    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
        ChangeNotifierProvider<MapViewModel>(
          create: (_) => MapViewModel(),
        ),
        ChangeNotifierProvider<RegistrationViewModel>(
          create: (_) => RegistrationViewModel(),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),
      ],
      child: Consumer<LoginStore>(
        builder: (ctx, auth, _) => MaterialApp(
          supportedLocales: const [
            Locale('en', ''),
            Locale('de', ''),
          ],
          key: GlobalVariable.scaffoldKey,
          title: 'Hop On',
          navigatorKey: Get.key,
          debugShowCheckedModeBanner: false,
          theme: Styles.lightTheme,
          home: WithNotifications(
            key: UniqueKey(),
            child: Builder(
              builder: (context) {
                final Size size = MediaQuery.of(context).size;
                SizeConfig.init(
                  context,
                  height: size.height,
                  width: size.width,
                  allowFontScaling: true,
                );
                return isAuthenticated ? MapScreen() : AuthScreen();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    setState(() {
      isAuthenticated = accessToken != null;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    checkAuthenticationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
