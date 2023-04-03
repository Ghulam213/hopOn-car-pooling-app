import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

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
                    if (val == null) return 'Pick Vehicle Photo';
                  },
                  onChanged: (_file) {},
                ),
                CustomImageFormField(
                  label: 'Pick license back',
                  validator: (val) {
                    if (val == null) return 'Pick Vehicle Registation';
                  },
                  onChanged: (_file) {},
                ),
              ],
            ),
          )),
      Step(
        state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 1,
        title: const Text('Driver Registration'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: _config.sh(40).toDouble(),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          tr("Driver registration information"),
                          style: const TextStyle(
                              color: AppColors.FONT_GRAY,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(40).toDouble(),
                    ),
                    CustomImageFormField(
                      label: 'Pick cnic front',
                      validator: (val) {
                        if (val == null) return 'Pick cnic front';
                      },
                      onChanged: (_file) {},
                    ),
                    const SizedBox(height: 8),
                    CustomImageFormField(
                      label: 'Pick cnic back',
                      validator: (val) {
                        if (val == null) return 'Pick cnic back';
                      },
                      onChanged: (_file) {},
                    ),
                    const SizedBox(height: 8),
                    CustomImageFormField(
                      label: 'Pick incense front',
                      validator: (val) {
                        if (val == null) return 'Pick incense front';
                      },
                      onChanged: (_file) {},
                    ),
                    const SizedBox(height: 8),
                    CustomImageFormField(
                      label: 'Pick license back',
                      validator: (val) {
                        if (val == null) return 'Pick license back';
                      },
                      onChanged: (_file) {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              type: StepperType.vertical,
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
                return StepControlBuilder(
                    details: details,
                    activeStepIndex: _activeStepIndex,
                    isLastStep: isLastStep);
              },
            ),
          ),
        );
      },
    );
  }
}

class CustomImageFormField extends StatefulWidget {
  CustomImageFormField({
    Key? key,
    required this.label,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);

  String label;
  final String? Function(File?) validator;
  final Function(File) onChanged;

  @override
  State<CustomImageFormField> createState() => _CustomImageFormFieldState();
}

class _CustomImageFormFieldState extends State<CustomImageFormField> {
  File? _pickedFile;

  bool isPicking = false;

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
        validator: widget.validator,
        builder: (formFieldState) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  FilePickerResult? file = await FilePicker.platform.pickFiles(
                      dialogTitle: widget.label,
                      type: FileType.image,
                      allowMultiple: false);
                  setState(() {
                    isPicking = true;
                  });

                  if (file != null) {
                    _pickedFile = File(file.files.first.path!);

                    isPicking = true;
                    widget.onChanged.call(_pickedFile!);
                  }
                },
                child: Card(
                  elevation: 5,
                  color: AppColors.LM_BACKGROUND_BASIC,
                  child: Container(
                    width: 300,
                    height: 60,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.image_outlined,
                            size: 36, color: AppColors.PRIMARY_500),
                        Text(
                          widget.label,
                          textAlign: TextAlign.center,
                        ),
                        !isPicking
                            ? Icon(Icons.check_outlined,
                                size: 21, color: AppColors.FONT_GRAY)
                            : Icon(Icons.check,
                                size: 21, color: AppColors.PRIMARY_500),
                      ],
                    ),
                  ),
                ),
              ),
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: Text(
                    formFieldState.errorText!,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 13,
                        color: Colors.red[700],
                        height: 0.5),
                  ),
                )
            ],
          );
        });
  }
}

class StepControlBuilder extends StatelessWidget {
  const StepControlBuilder({
    super.key,
    required ControlsDetails details,
    required int activeStepIndex,
    required this.isLastStep,
  })  : _activeStepIndex = activeStepIndex,
        _details = details;

  final int _activeStepIndex;
  final ControlsDetails _details;
  final bool isLastStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          if (_activeStepIndex > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: _details.onStepCancel,
                child: Text('Back',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: AppColors.LM_BACKGROUND_BASIC)),
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _details.onStepContinue,
              child: (isLastStep)
                  ? Text('Submit',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          color: AppColors.LM_BACKGROUND_BASIC))
                  : Text('Next',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          color: AppColors.LM_BACKGROUND_BASIC)),
            ),
          ),
        ],
      ),
    );
  }
}