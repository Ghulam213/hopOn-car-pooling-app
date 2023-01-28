import 'dart:async';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:hop_on/utils/colors.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  static const routeName = '/otp';
  // passed from previous screen
  final String? phoneNumber;
  // constructor
  const OtpPage({
    Key? key,
    this.phoneNumber = '',
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

  void _setCode(int position, String value) {
    setState(() {
      code[position] = value;
    });
  }



  void _onKeyboardTap(String value) {

    setState(() {
      text = text.length <= 6 ? text + value : text;
    });
    debugPrint(text);
  }

//      loginStore.validateOtpAndLogin(context, text);

  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();
  final _pin3 = TextEditingController();
  final _pin4 = TextEditingController();
  final _pin5 = TextEditingController();
  final _pin6 = TextEditingController();
  final _pin7 = TextEditingController();
  // final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  FocusNode? pin7FocusNode;

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

    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    pin7FocusNode = FocusNode();
  }

  @override
  void dispose() {
    AndroidSmsRetriever.stopSmsListener();
    super.dispose();
    pin1FocusNode!.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
    pin7FocusNode!.dispose();
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
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
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
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        child: Align(
                          alignment: context.locale.toString() == 'en'
                              ? Alignment.centerLeft
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidthDp! * 0.03),
                            child: Text(
                                ez.tr("An 6 digit code hase been sent to " +
                                    widget.phoneNumber.toString()),
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
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          otpNumberWidget(
                              _pin1, pin1FocusNode, pin2FocusNode, 0),
                          otpNumberWidget(
                              _pin1, pin2FocusNode, pin3FocusNode, 1),
                          otpNumberWidget(
                              _pin1, pin3FocusNode, pin4FocusNode, 2),
                          otpNumberWidget(
                              _pin1, pin4FocusNode, pin5FocusNode, 3),
                          otpNumberWidget(
                              _pin1, pin5FocusNode, pin6FocusNode, 4),
                          otpNumberWidget(
                              _pin1, pin6FocusNode, pin7FocusNode, 5,
                              isLast: true),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      NumericKeyboard(
                        onKeyboardTap: _onKeyboardTap,
                        textColor: AppColors.PRIMARY_500,
                        rightIcon: const Icon(
                          Icons.backspace,
                          color: AppColors.PRIMARY_500,
                        ),
                        rightButtonFn: () {
                          setState(() {
                            text = text.isNotEmpty
                                ? text.substring(0, text.length - 1)
                                : text;
                          });
                        },
                      ),
                      SizedBox(height: _config.uiHeightPx * 0.075),
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

  Widget otpNumberWidget(TextEditingController _tcontroller, FocusNode? _fnode,
      FocusNode? _nextfocus, int _position,
      {bool isLast = false}) {
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
