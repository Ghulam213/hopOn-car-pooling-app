// ignore_for_file: prefer_const_constructors
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/screens/login_screen.dart';
import 'package:hop_on/core/auth/screens/signup_screen.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class AuthScreen extends StatefulWidget {
  static const routeName = '/authScreen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SizeConfig config = SizeConfig();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: (MediaQuery.of(context).viewInsets.bottom > 0.0)
                          ? (config.uiHeightPx * 0.10).toDouble()
                          : (config.uiHeightPx * 0.20).toDouble()),
                  Lottie.asset(
                    "assets/animations/waiting.json",
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Lets hop On',
                          style: TextStyle(
                              color: AppColors.PRIMARY_500,
                              fontSize: 38,
                              fontWeight: FontWeight.w700))),
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 40),
                      child: Text('your daily traveling partner',
                          style: TextStyle(
                              color: AppColors.PRIMARY_500,
                              fontSize: 15,
                              fontWeight: FontWeight.w500))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: LoginButton(
                      text: ez.tr('Log In'),
                      isLoading: loginStore.isPhoneLoading,
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                    ),
                  ),
                  LoginButton(
                    text: ez.tr('Register'),
                    isLoading: loginStore.isPhoneLoading,
                    onPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                  ),
                  SizedBox(
                      height: (MediaQuery.of(context).viewInsets.bottom > 0.0)
                          ? (config.uiHeightPx * 0.0375).toDouble()
                          : (config.uiHeightPx * 0.085).toDouble()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
