import 'dart:developer';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';

import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/widgets/country_picker.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:provider/provider.dart';

import 'otp_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const routeName = '/phoneAuth';

  // constructor
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final SizeConfig _config = SizeConfig();
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneController = TextEditingController();

  String countryCode = '';
  String number = '';
  String fullCode = '';
  String? _applicationSignature;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      try {
        getSignature();
      } catch (e) {
        Sentry.captureMessage("PhoneAuthScreen:initState() ${e.toString()}");
        log("Error getting app signature");

        log(e.toString());
      }
    }
  }

  Future<void> getSignature() async {
    final String? signature = await AndroidSmsRetriever.getAppSignature();
    if (signature != null) {
      setState(() {
        _applicationSignature = signature;
      });
    }
  }

  bool isSuccess = false;
  bool isFailure = false;
  final TextEditingController controller = TextEditingController();

  Future _performAction(String contact, String code) async {
    setState(() => number = contact);
    setState(() => countryCode = code);
    _formKey.currentState!.save();
    setState(() => fullCode = countryCode + number);

    log(fullCode);
  }

  Future _endAction() async {}

  void _clearField() {
    FocusScope.of(context).unfocus();
    _phoneController.clear();
  }

  void dismissFocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (context, loginStore, _) {
      return
          //  Observer(
          //   builder: (_) =>
          Scaffold(
              key: _scaffoldKey,
              body: Form(
                key: _formKey,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //     height:
                          //         (MediaQuery.of(context).viewInsets.bottom >
                          //                 0.0)
                          //             ? (_config.uiHeightPx * 0.10).toDouble()
                          //             : (_config.uiHeightPx * 0.25).toDouble()),

                          Text(
                            'Enter your mobile number',
                            style: const TextStyle(
                                color: AppColors.LM_FONT_SECONDARY_GREY8,
                                fontSize: 15),
                          ),
                      
                          Text(
                            'We will send you a confirmation code ',
                            style: const TextStyle(
                                color: AppColors.LM_FONT_SECONDARY_GREY8,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: _config.sh(80).toDouble(),
                            width: SizeConfig.screenWidthDp! * 0.94,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ContactInputField(
                                  (contact, code, _) =>
                                      _performAction(contact, code!),
                                  () => _endAction(),
                                  false,
                                  false,
                                  controller),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidthDp! * 0.84,
                            child: LoginButton(
                              text: ez.tr('Next'),
                              isLoading: loginStore.isPhoneLoading,
                              onPress: () {
                                loginStore.phoneLogin(
                                    context, fullCode, _applicationSignature);
                                if (loginStore.isPhoneDone == true) {
                                  _clearField();
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          OtpPage(phoneNumber: fullCode)),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                              height:
                                  (MediaQuery.of(context).viewInsets.bottom >
                                          0.0)
                                      ? (_config.uiHeightPx * 0.2).toDouble()
                                      : (_config.uiHeightPx * 0.6).toDouble()),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              // ),
              );
    });
  }
}
