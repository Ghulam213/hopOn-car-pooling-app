import 'dart:async';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
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
  const OtpPage(
      {
    Key? key,
    this.phoneNumber = '',
  })
      : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final SizeConfig _config = SizeConfig();
  //otpMode _otpMode = otpMode.phone;

  final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance!.window.viewInsets,
      WidgetsBinding.instance!.window.devicePixelRatio);

  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();
  final _pin3 = TextEditingController();
  final _pin4 = TextEditingController();
  final _pin5 = TextEditingController();
  final _pin6 = TextEditingController();

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
      text = text + value;
    });
  }

  final Map<String, String> _phoneOTP = {
    'phone': '',
    'tfa': 'false',
    'verification_code': ''
  };

  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

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

    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    AndroidSmsRetriever.stopSmsListener();
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
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
        _pinPutController.text = _smsCode;
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

  @override
  Widget build(BuildContext context) {
    // Amplitude.getInstance().logEvent('OTP verification screen started');

    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 1),
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 2,
        color: AppColors.LM_BUTTON_NORMAL_BLUE6,
      ),
    );

    final BoxDecoration onFieldFocus = BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 1),
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 2,
        color: AppColors.LM_BACKGROUND_GREY1,
      ),
    );

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
                  bottom: (MediaQuery.of(context).viewInsets.bottom + 0 > 0.0)
                      ? 0
                      : 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              (MediaQuery.of(context).viewInsets.bottom > 0.0)
                                  ? (_config.uiHeightPx * 0.10).toDouble()
                                  : (_config.uiHeightPx * 0.31).toDouble()),
                     
                      SizedBox(
                                child: Align(
                                  alignment: context.locale.toString() == 'en'
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenWidthDp! * 0.03),
                                    child: Text(ez.tr("Enter your OTP Code"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: AppColors
                                                    .LM_FONT_SECONDARY_GREY8)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SizedBox(
                                  child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Pinput(
                                  length: 6,
                                  onCompleted: (String pin) {
                                    _codeJoined = code.join();
                                    _phoneOTP['verification_code'] =
                                        _codeJoined;
                              
                                      loginStore.validateOtpAndLogin(
                                          context,
                                          pin,

                                          // _emailOTP['phone'] =
                                widget.phoneNumber!);
                                  
                                    if (loginStore.isOtpDone == true) {
                                      _pinPutFocusNode.unfocus();
                                    }
                                  },
                                  focusedPinTheme: PinTheme(
                                    margin: const EdgeInsets.all(0),
                                    height: 50.0,
                                    width: 50.0,
                                    textStyle: const TextStyle(fontSize: 16),
                                    decoration: pinPutDecoration
                                      ..copyWith(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 2,
                                          color:
                                              AppColors.LM_BUTTON_NORMAL_BLUE6,
                                        ),
                                      ),
                                  ),
                                  followingPinTheme: PinTheme(
                                    margin: const EdgeInsets.all(0),
                                    height: 50.0,
                                    width: 50.0,
                                    textStyle: const TextStyle(fontSize: 16),
                                    decoration: onFieldFocus,
                                  ),
                                  errorPinTheme: PinTheme(
                                    margin: const EdgeInsets.all(0),
                                    height: 50.0,
                                    width: 50.0,
                                    textStyle: const TextStyle(fontSize: 16),
                                    decoration: pinPutDecoration
                                      ..copyWith(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.LM_FONT_ERROR_RED6,
                                        ),
                                      ),
                                  ),
                                  defaultPinTheme: PinTheme(
                                    margin: const EdgeInsets.all(0),
                                    height: 50.0,
                                    width: 50.0,
                                    textStyle: const TextStyle(fontSize: 16),
                                    decoration: pinPutDecoration,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber
                                  ],
                                  focusNode: _pinPutFocusNode,
                                  controller: _pinPutController,
                                ),
                              )),
                      Card(
                        color: AppColors.LM_BACKGROUND_GREY3,
                        child: SizedBox(
                          width: SizeConfig.screenWidthDp,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 11,
                              ),
                             
                              SizedBox(
                                  height: (MediaQuery.of(context)
                                              .viewInsets
                                              .bottom >
                                          0.0)
                                      ? (_config.uiHeightPx * 0.02).toDouble()
                                      : (_config.uiHeightPx * 0.05).toDouble()),
                              NumericKeyboard(
                                onKeyboardTap: _onKeyboardTap,
                                textColor: Colors.black,
                                rightIcon: Icon(
                                  Icons.backspace,
                                  color: Colors.black,
                                ),
                                rightButtonFn: () {
                                  setState(() {
                                    text = text.substring(0, text.length - 1);
                                  });
                                },
                              ),

                              // onPress: () {
                              //         setState(() {
                              //           _codeJoined = code.join();

                              //           if (_codeJoined.length < 6) {
                              //             _phoneOTP['verification_code'] =
                              //                 _codeJoined;

                              //               loginStore.validateOtpAndLogin(
                              //                   context,
                              //                   _codeJoined,
                              //                   // _emailOTP['phone'] =
                              //                   widget.phoneNumber!);

                              //             // clearing focus from all fields
                              //             Future.delayed(
                              //               const Duration(seconds: 1),
                              //               () {
                              //                 _pin1.clear();
                              //                 _pin2.clear();
                              //                 _pin3.clear();
                              //                 _pin4.clear();
                              //                 _pin5.clear();
                              //                 _pin6.clear();
                              //               },
                              //             );
                              //           }
                              //         });
                              //       },
                              SizedBox(
                                  height: (MediaQuery.of(context)
                                              .viewInsets
                                              .bottom >
                                          0.0)
                                      ? (_config.uiHeightPx * 0.0375).toDouble()
                                      : (_config.uiHeightPx * 0.075)
                                          .toDouble()),
                            ],
                          ),
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

  Widget digitField(TextEditingController _tcontroller, FocusNode? _fnode,
      FocusNode? _nextfocus, int _poition, bool isLast) {
    return SizedBox(
      width: _config.sh(48).toDouble(),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 1,
              offset: const Offset(0, 1),
              spreadRadius: 0.4),
        ], borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: TextFormField(
          maxLength: 1,
          textInputAction: TextInputAction.next,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: _tcontroller,
          focusNode: _fnode,
          textAlignVertical: TextAlignVertical.center,
          autofocus: true,
          enableSuggestions: false,
          autocorrect: false,
          cursorColor: AppColors.LM_BUTTON_NORMAL_BLUE6,
          obscureText: true,
          style: const TextStyle(fontSize: 32),
          keyboardType: TextInputType.visiblePassword,
          textAlign: TextAlign.center,
          onChanged: (value) {
            _setCode(_poition, value);
            _onKeyboardTap(value);
            nextField(value, _nextfocus);
          },
        ),
      ),
    );
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
