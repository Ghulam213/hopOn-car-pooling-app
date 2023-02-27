import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';
import 'driver_info_modal.dart';

class VehicleInfoModal extends StatefulWidget {
  final Function() onCloseTap;
  final Function(String) onErrorOccurred;

  VehicleInfoModal(
      {Key? key, required this.onCloseTap, required this.onErrorOccurred})
      : super(key: key);

  @override
  _VehicleInfoModalState createState() => _VehicleInfoModalState();
}

class _VehicleInfoModalState extends State<VehicleInfoModal> {
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SizeConfig _config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  int _activeStepIndex = 0;

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController age = TextEditingController();

  List<Step> stepList() {
    var textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 18, color: AppColors.PRIMARY_500);

    return [
      Step(
        state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: const Text('Information'),
        content: Container(
          child: Column(
            children: [
              TextField(
                controller: fName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Vehicle Brand',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: lName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Vehicle Model',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: lName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Vehicle Color',
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Images'),
          content: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                CustomImageFormField(
                  label: 'Pick license back',
                  validator: (val) {
                    if (val == null) return 'Pick license back';
                  },
                  onChanged: (_file) {},
                ),
                CustomImageFormField(
                  label: 'Pick license back',
                  validator: (val) {
                    if (val == null) return 'Pick license back';
                  },
                  onChanged: (_file) {},
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
          content: Center(
            child: Text(
              'Wait for confirmation',
              style: textStyle,
            ),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      initialChildSize: 0.95,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          color: AppColors.LM_BACKGROUND_BASIC,
          child:
              // SizedBox(
              //   height: _config.sh(120).toDouble(),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 13.0),
              //   child: Text(
              //     tr("Please fill in the required information"),
              //     style: const TextStyle(
              //         color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
              //         fontSize: 17,
              //         fontWeight: FontWeight.w400),
              //   ),
              // ),

              Container(
            width: _config.scaleWidth * 0.9,
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _activeStepIndex,
              steps: stepList(),
              onStepContinue: () {
                if (_activeStepIndex < (stepList().length - 1)) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                } else {
                  // loginStore.registerUser(context, password.text, phone.text,
                  //     email.text, fName.text, lName.text);
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
                final isLastStep = _activeStepIndex == stepList().length - 1;

                setState(() {
                  _activeStepIndex = index;
                });
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = _activeStepIndex == stepList().length - 1;

                return Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      if (_activeStepIndex < 2)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(
                                (_activeStepIndex == 0) ? 'Next' : 'Submit',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        height: 1.0,
                                        color: AppColors.LM_BACKGROUND_BASIC)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
