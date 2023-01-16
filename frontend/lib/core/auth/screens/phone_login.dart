import 'dart:developer';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/widgets/country_picker.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:hop_on/utils/colors.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:provider/provider.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const routeName = '/phoneAuth';

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
                        children: [
                          SizedBox(
                              height:
                                  (MediaQuery.of(context).viewInsets.bottom >
                                          0.0)
                                      ? (_config.uiHeightPx * 0.10).toDouble()
                                      : (_config.uiHeightPx * 0.25).toDouble()),
                          Card(
                            color: AppColors.LM_BACKGROUND_GREY3,
                            child: SizedBox(
                              width: SizeConfig.screenWidthDp,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 11,
                                    ),
                                    SizedBox(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        // context.locale.toString() == 'en'
                                        //     ? Alignment.centerLeft
                                        //     : Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: SizeConfig.screenWidthDp! *
                                                  0.03),
                                          child: Text(
                                              ez.tr('Enter your mobile number'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .LM_FONT_SECONDARY_GREY8),
                                              textDirection: TextDirection.rtl),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      height: _config.sh(80).toDouble(),
                                      width: SizeConfig.screenWidthDp! * 0.94,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                    // SizedBox(
                                    //     height: (MediaQuery.of(context)
                                    //                 .viewInsets
                                    //                 .bottom >
                                    //             0.0)
                                    //         ? (_config.uiHeightPx * 0.02)
                                    //             .toDouble()
                                    //         : (_config.uiHeightPx * 0.05)
                                    //             .toDouble()),
                                    SizedBox(
                                        width: SizeConfig.screenWidthDp! * 0.94,
                                        child: LoginButton(
                                          text: ez.tr('Log In'),
                                          isLoading: loginStore.isPhoneLoading,
                                          onPress: () {
                                            loginStore.phoneLogin(
                                                context,
                                                fullCode,
                                                _applicationSignature);
                                            if (loginStore.isPhoneDone ==
                                                true) {
                                              _clearField();
                                            }
                                          },
                                        )),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        // width: SizeConfig.screenWidthDp,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            // width: SizeConfig.screenWidthDp! * 0.9,
                                            child: CupertinoButton(
                                              color:
                                                  AppColors.LM_BACKGROUND_GREY3,
                                              onPressed: () {
                                                // Navigator.of(context)
                                                //     .pushReplacement(
                                                //   MaterialPageRoute(
                                                //       builder: (_) =>
                                                //           EmailAuthScreen()),
                                                // );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Text(
                                                    ez.tr(
                                                        'Continue with e-mail'),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .LM_FONT_SECONDARY_GREY8)),
                                              ),
                                            ),
                                          ),
                                          const Text('|'),
                                          SizedBox(
                                            // width: SizeConfig.screenWidthDp! * 0.9,
                                            child: CupertinoButton(
                                              color:
                                                  AppColors.LM_BACKGROUND_GREY3,
                                              onPressed: () async {
                                                if (context.locale.toString() ==
                                                    'en') {
                                                  await context.setLocale(
                                                      const Locale('ar', ''));
                                                } else {
                                                  await context.setLocale(
                                                      const Locale('en', ''));
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Text(ez.tr('Languages'),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .LM_FONT_SECONDARY_GREY8)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(
                                        height: (MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom >
                                                0.0)
                                            ? (_config.uiHeightPx * 0.0375)
                                                .toDouble()
                                            : (_config.uiHeightPx * 0.075)
                                                .toDouble()),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
