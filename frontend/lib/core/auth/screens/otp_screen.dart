import 'dart:async';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:hop_on/core/auth/screens/register_info_screen.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:hop_on/core/profile/screens/profile_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:hop_on/utils/colors.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  static const routeName = '/otp';
  // passed from previous screen
  final String? phoneNumber;
  final String otpmode;
  
  const OtpPage({
    Key? key,
    this.phoneNumber = '',
    required this.otpmode,
  }) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final SizeConfig _config = SizeConfig();

  final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance!.window.viewInsets,
      WidgetsBinding.instance!.window.devicePixelRatio);

  String text = '';
  String _codeJoined = '';

  // array to store joined code
  List<String> code = ['', '', '', '', '', ''];

  void _onKeyboardTap(String value) {

    setState(() {
      text = text.length <= 6 ? text + value : text;
    });
    debugPrint(text);
  }
  String _applicationSignature = "";
  String _smsCode = "";

  bool isListening = false;
  bool consentLoading = false;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      initSmsListener();
    }
  }

  @override
  void dispose() {
    AndroidSmsRetriever.stopSmsListener();
    super.dispose();

  }

  String otpCode = '';

  Future<void> initSmsListener() async {
    AndroidSmsRetriever.startSmsListener().then((value) {
      setState(() {
        final intRegex = RegExp(r'\d+', multiLine: true);
        final code = intRegex
            .allMatches(value ?? 'Phone Number Not Found')
            .first
            .group(0);
        _smsCode = code ?? 'NO CODE';
        // _pinPutController.text = _smsCode;
        AndroidSmsRetriever.stopSmsListener();
      });
    });
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  String getCode(String sms) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    final code = intRegex.allMatches(sms).first.group(0);
    return code ?? 'NO CODE';
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 1),
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 2,
      color: AppColors.PRIMARY_500,
      ),
    );


  @override
  Widget build(BuildContext context) {

    return Consumer<LoginStore>(builder: (_, loginStore, __) {

      if (widget.otpmode == 'login') {
        loginStore.validateOtpAndLogin(
            context,
            _codeJoined,
            // _emailOTP['phone'] =
            widget.phoneNumber!);
      } else if (widget.otpmode == 'register') {
        loginStore.validateOtpAndLogin(
            // TO DO : Update
            context,
            _codeJoined,
            widget.phoneNumber!);
      }
      return Observer(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.LM_BACKGROUND_GREY1,
          body: Form(
            key: loginStore.otpScaffoldKey,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Column(
                    children: [

                      Lottie.asset(
                        "assets/animations/otp.json",
                        height: 300.0,
                        width: 250.0,
                      ),
                    
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 12),
                        child: Align(
                          alignment: context.locale.toString() == 'en'
                              ? Alignment.centerLeft
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidthDp! * 0.03),
                            child: Text(ez.tr("Enter OTP"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                        color: AppColors.PRIMARY_500)),
                          ),
                        ),
                      ),
                   
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Align(
                          alignment: context.locale.toString() == 'en'
                              ? Alignment.centerLeft
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidthDp! * 0.03),
                            child: Text(
                                ez.tr(
                                    'An 6 digit code hase been sent to ${widget.phoneNumber}'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color:
                                            AppColors.LM_FONT_SECONDARY_GREY8)),
                          ),
                        ),
                      ),
                   
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          otpNumberWidget(0),
                          otpNumberWidget(1),
                          otpNumberWidget(2),
                          otpNumberWidget(3),
                          otpNumberWidget(4),
                          otpNumberWidget(5),
                        ],
                      ),
                    
                      Padding(
                        padding: EdgeInsets.only(
                            top: 16, bottom: _config.uiHeightPx * 0.075),
                        child: NumericKeyboard(
                          onKeyboardTap: _onKeyboardTap,
                          textColor: AppColors.PRIMARY_500,

                          rightIcon: const Icon(
                            Icons.check,
                            color: AppColors.PRIMARY_500,
                          ),
                          rightButtonFn: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => ProfileScreen()),
                            );
                            // if (widget.otpmode == 'login') {
                            //   loginStore.validateOtpAndLogin(
                            //       context,
                            //       _codeJoined,
                            //       // _emailOTP['login'] =
                            //       widget.phoneNumber!);
                            // } else if (widget.otpmode == 'register') {
                            //   loginStore.validateOtpAndLogin(
                            //       context,
                            //       _codeJoined,
                            //       //_emailOTP['register'] =
                            //       widget.phoneNumber!);
                            // }
                          },
                          leftIcon: const Icon(
                            Icons.backspace,
                            color: AppColors.PRIMARY_500,
                          ),
                          leftButtonFn: () {
                            setState(() {
                              text = text.isNotEmpty
                                  ? text.substring(0, text.length - 1)
                                  : text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget otpNumberWidget(int _position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: pinPutDecoration
          ..copyWith(
            color: Colors.white,
            border: Border.all(width: 2, color: AppColors.PRIMARY_500),
          ),
        child: Center(
            child: Text(
          text[_position],
          // focusNode: _fnode,
          // controller: _tcontroller,
          style: const TextStyle(color: AppColors.BLACK),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 2,
            color: AppColors.PRIMARY_300,
          ),
        ),
      );
    }
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
