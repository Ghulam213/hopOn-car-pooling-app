// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hop_on/Utils/colors.dart';

import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/widgets/country_picker.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets/loader.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/phoneAuth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SizeConfig _config = SizeConfig();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        Sentry.captureMessage('PhoneAuthScreen:initState() ${e.toString()}');
        log("Error getting app signature${e.toString()}");
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

  void _clearField() {
    FocusScope.of(context).unfocus();
    phoneController.clear();
    passwordController.clear();
  }

  Future _performAction(String contact, String code) async {
    setState(() => number = contact);
    setState(() => countryCode = code);
    _formKey.currentState!.save();
    setState(() => fullCode = countryCode + number);

    log(fullCode);
  }

  Future _endAction() async {}

  void dismissFocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: false, // TODO: add loading state
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              height:
                                  (MediaQuery.of(context).viewInsets.bottom >
                                          0.0)
                                      ? (_config.uiHeightPx * 0.10).toDouble()
                                      : (_config.uiHeightPx * 0.25).toDouble()),
                          Text('Welcome back',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: AppColors.PRIMARY_500,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'We will send you a code on this mobile number',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AppColors.PRIMARY_500,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ]),
                              )),
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
                                  phoneController),
                            ),
                          ),
                          Container(
                              width: SizeConfig.screenWidthDp! * 0.94,
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: 'enter password',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AppColors.PRIMARY_500,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ]),
                              )),
                          PasswordInput(
                            config: _config,
                            controller: passwordController,
                          ),
                          LoginButton(
                            text: ez.tr('Log In'),
                            isLoading: loginStore.isPhoneLoading,
                            onPress: () {                      
                              loginStore.phoneLogin(
                                  context, fullCode, passwordController.text);
                              if (loginStore.isPhoneDone == true) {
                                _clearField();
                              }
                            },
                          ),
                          SizedBox(
                              height: (MediaQuery.of(context)
                                          .viewInsets
                                          .bottom >
                                      0.0)
                                  ? (_config.uiHeightPx * 0.0375).toDouble()
                                  : (_config.uiHeightPx * 0.085).toDouble()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.config,
    required this.controller,
  });

  final TextEditingController controller;
  final SizeConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.sh(80).toDouble(),
      width: SizeConfig.screenWidthDp! * 0.94,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
              keyboardType: TextInputType.number,
              cursorColor: AppColors.PRIMARY_500,
              controller: controller,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 15, height: 1.0, color: AppColors.grey1),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: const TextStyle(
                    color: AppColors.grey1,
                    fontSize: 14,
                  ),
                  hintText: "",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.grey1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.red1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            AppColors.LM_FONT_BLOCKTEXT_GREY7.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.red1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.BLUE,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  )))),
    );
  }
}
