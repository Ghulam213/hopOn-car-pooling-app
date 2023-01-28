// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hop_on/Utils/colors.dart';

import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/widgets/country_picker.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:lottie/lottie.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets/loader.dart';
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
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: false,
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
                        children: <Widget>[
                        
                          SizedBox(
                              height:
                                  (MediaQuery.of(context).viewInsets.bottom >
                                          0.0)
                                      ? (_config.uiHeightPx * 0.10).toDouble()
                                      : (_config.uiHeightPx * 0.25).toDouble()),
                          Lottie.asset(
                            "assets/animations/waiting.json",
                            // height: 300.0,
                            // width: 250.0,
                          ),
                             
                        
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Lets Hop On',
                                  style: TextStyle(
                                      color: AppColors.PRIMARY_500,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800)))
                          ,
                          SizedBox(height: 20),
                          Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                          const SizedBox(
                            height: 20,
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
                          LoginButton(
                            text: ez.tr('Log In'),
                            isLoading: loginStore.isPhoneLoading,
                            onPress: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        OtpPage(phoneNumber: '336055566')),
                              );
                              // loginStore.phoneLogin(
                              //     context, fullCode, _applicationSignature);
                              // if (loginStore.isPhoneDone == true) {
                              //   _clearField();
                              // }
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
