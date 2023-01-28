// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
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
import 'package:provider/provider.dart';

import 'Utils/styles.dart';

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
  await EasyLocalization.ensureInitialized();
  NetworkConfig().initNetworkConfig();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', ''), Locale('de', '')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', ''),
      child: const App()));
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
        ],
        child: Consumer<LoginStore>(
          builder: (ctx, auth, _) => MaterialApp(
            supportedLocales: const [
              Locale('en', ''), Locale('de', '')
            ],

            key: GlobalVariable.scaffoldKey,
            onGenerateRoute: RouteGenerator.generateRoute,
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

                return const SplashScreen();
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
