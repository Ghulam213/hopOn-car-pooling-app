// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';

import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/auth/provider/login_store.dart';
import 'package:hop_on/core/auth/screens/otp_screen.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/authScreen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SizeConfig _config = SizeConfig();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController age = TextEditingController();

  int _activeStepIndex = 0;

  void onStepContinue() {
    _activeStepIndex += 1;
  }

  void onStepCancel() {
    _activeStepIndex -= 1;
  }

  List<Step> stepList() {
    var textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 18, color: AppColors.PRIMARY_500);

    return [
      Step(
        state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: const Text('Account'),
        content: Container(
          child: Column(
            children: [
              TextField(
                controller: fName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              TextField(
                controller: lName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Information'),
          content: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          )),
      Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text('Confirm'),
          content: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Last Name: ${email.text}',
                style: textStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Phone: ${phone.text}',
                style: textStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Email : ${email.text}',
                style: textStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Password : ${password.text}', style: textStyle),
            ],
          ))),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        var inputDecoration = InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.LM_BUTTON_NORMAL_BLUE6,
              ),
            ),
            fillColor: AppColors.LM_BACKGROUND_GREY1,
            filled: true,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            helperText: ' ',
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'example@email.com',
            hintStyle: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.LM_FONT_DISABLE_GREY5));
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                      height: (MediaQuery.of(context).viewInsets.bottom > 0.0)
                          ? (_config.uiHeightPx * 0.10).toDouble()
                          : (_config.uiHeightPx * 0.15).toDouble()),
                  Text('Your Information',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.PRIMARY_500,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                  SizedBox(height: 20),
                  Stepper(
                    type: StepperType.vertical,
                    currentStep: _activeStepIndex,
                    steps: stepList(),
                    onStepContinue: () {
                      if (_activeStepIndex < (stepList().length - 1)) {
                        setState(() {
                          _activeStepIndex += 1;
                        });
                      } else {
                        loginStore.registerUser(context, password.text,
                            phone.text, email.text, fName.text, lName.text);

                     
                        
                      }
                    },
                    onStepCancel: () {
                      if (_activeStepIndex == 0) {
                        return;
                      }

                      setState(() {
                        _activeStepIndex -= 1;
                      });
                    },
                    onStepTapped: (int index) {
                      final isLastStep =
                          _activeStepIndex == stepList().length - 1;
            
                   
                      setState(() {
                        _activeStepIndex = index;
                      });
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      final isLastStep =
                          _activeStepIndex == stepList().length - 1;

                      return Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            if (_activeStepIndex > 0)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('Back',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              height: 1.0,
                                              color: AppColors
                                                  .LM_BACKGROUND_BASIC)),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: (isLastStep)
                                    ? Text('Submit',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                height: 1.0,
                                                color: AppColors
                                                    .LM_BACKGROUND_BASIC))
                                    : Text('Next',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                height: 1.0,
                                                color: AppColors
                                                    .LM_BACKGROUND_BASIC)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )),
            ),
          ),
        );
      },
    );
  }
}
