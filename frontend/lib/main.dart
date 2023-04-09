// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hop_on/core/auth/screens/auth_screen.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:hop_on/core/registration/viewmodel/registration_viewmodel.dart';
import 'package:latlong2/latlong.dart';
import 'core/map/viewmodel/map_view_model.dart';
import 'core/profile/viewmodel/profile_viewmodel.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/config/network/network_config.dart';
import 'package:hop_on/config/routes/routes.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/onboarding/screens/splash_screen.dart';
import 'package:hop_on/utils/colors.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/styles.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SentryFlutter.init(
  //     (options) => {
  //           options.attachStacktrace = true,
  //           // options.sampleRate = 0.5, // send only 50% of the events randomlly
  //           options.sendDefaultPii = true,
  //         },
  //     appRunner: () => {
  //           EasyLocalization.ensureInitialized(),
  //           NetworkConfig().initNetworkConfig(),
  //           SystemChrome.setPreferredOrientations(
  //               [DeviceOrientation.portraitUp]).then(
  //             (value) => runApp(EasyLocalization(
  //                 supportedLocales: const [Locale('en', ''), Locale('ar', '')],
  //                 path:
  //                     'assets/translations', // <-- change the path of the translation files
  //                 fallbackLocale: const Locale('en', ''),
  //                 child: const App())),
  //           )
  //         });
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  await EasyLocalization.ensureInitialized();
  NetworkConfig().initNetworkConfig();
  await initializeLocationAndSave();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', ''), Locale('de', '')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', ''),
      child: const App()));
}

initializeLocationAndSave() async {
  sharedPreferences = await SharedPreferences.getInstance();
  Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
  }

  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
  }

// Get capture the current user location
  LocationData _locationData = await _location.getLocation();
  LatLng currentLatLng =
      LatLng(_locationData.latitude!, _locationData.longitude!);

// Store the user location in sharedPreferences
  setSharedPrefs('currentLatLong', currentLatLng.toString());
}

class App extends StatefulWidget {
  const App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: AppColors.RED,
    ));

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
            supportedLocales: const [Locale('en', ''), Locale('de', '')],

            key: GlobalVariable.scaffoldKey,
            title: 'hopOn',
            navigatorKey: Get.key,
            debugShowCheckedModeBanner: false,
            theme: Styles.lightTheme,
            home: Builder(
              builder: (context) {
                final Size size = MediaQuery.of(context).size;
                SizeConfig.init(context,
                    height: size.height,
                    width: size.width,
                    allowFontScaling: true);
                return MapScreen();
              },
            ),
          ),
        ));
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
