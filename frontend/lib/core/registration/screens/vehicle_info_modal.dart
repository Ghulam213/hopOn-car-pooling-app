import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../auth/widgets/login_button.dart';
import '../viewmodel/registration_viewmodel.dart';

class VehicleInfoModal extends StatefulWidget {
  final Function() onCloseTap;
  final Function(String) onErrorOccurred;

  const VehicleInfoModal(
      {Key? key, required this.onCloseTap, required this.onErrorOccurred})
      : super(key: key);

  @override
  _VehicleInfoModalState createState() => _VehicleInfoModalState();
}

class _VehicleInfoModalState extends State<VehicleInfoModal> {
  final SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  int _activeStepIndex = 0;

  TextEditingController vType = TextEditingController();
  TextEditingController vBrand = TextEditingController();
  TextEditingController vModel = TextEditingController();
  TextEditingController vColor = TextEditingController();
  TextEditingController vregNo = TextEditingController();

  String? cnicFrontUrl;

  List<Step> stepList({RegistrationViewModel? regViewModel}) {
    var textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 18, color: AppColors.PRIMARY_500);

    TextField formField(String text, TextEditingController controller) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
        ),
      );
    }

    return [
      Step(
        state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: const Text('Vehicle Information'),
        content: Column(
          children: [
            formField('Vehicle Type', vType),
            const SizedBox(height: 8),
            formField('Vehicle Brand', vBrand),
            const SizedBox(height: 8),
            formField('Vehicle Model', vModel),
            const SizedBox(height: 8),
            formField('Vehicle Color', vColor),
            const SizedBox(height: 8),
            formField('Vehicle Registration Number', vregNo),
            const SizedBox(height: 16),
          ],
        ),
      ),
      Step(
        state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 1,
        title: const Text('Upload Images'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CustomImageFormField(
                  label: 'Pick Cnic Front',
                  validator: (val) {
                    if (val == null) return 'Pick Cnic Front';
                    return null;
                  },
                  onChanged: (file) async {
                    var fName = await regViewModel?.uploadFile();
                    // setState(() {
                    //   cnicFrontUrl = fName;
                    // });
                  },
                ),
                const SizedBox(height: 8),
                CustomImageFormField(
                  label: 'Pick Cnic Back',
                  validator: (val) {
                    if (val == null) return 'Pick Cnic Back';
                    return null;
                  },
                  onChanged: (file) {},
                ),
                const SizedBox(height: 8),
                CustomImageFormField(
                  label: 'Pick License Front',
                  validator: (val) {
                    if (val == null) return 'Pick License Front';
                    return null;
                  },
                  onChanged: (file) {},
                ),
                const SizedBox(height: 8),
                CustomImageFormField(
                  label: 'Pick License Back',
                  validator: (val) {
                    if (val == null) return 'Pick License Back';
                    return null;
                  },
                  onChanged: (file) {},
                ),
                const SizedBox(height: 8),
                CustomImageFormField(
                  label: 'Vehicle Registration Paper',
                  validator: (val) {
                    if (val == null) return 'Registration Paper';
                    return null;
                  },
                  onChanged: (file) {},
                ),
                const SizedBox(height: 8),
                CustomImageFormField(
                  label: 'Vehicle Image',
                  validator: (val) {
                    if (val == null) return 'Vehicle Image';
                    return null;
                  },
                  onChanged: (file) {},
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
      Step(
          state: StepState.complete,
          // isActive: _activeStepIndex >= 2,
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
    final RegistrationViewModel regViewModel =
        context.watch<RegistrationViewModel>();

    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      initialChildSize: 0.95,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          color: AppColors.LM_BACKGROUND_BASIC,
          child: SizedBox(
            width: config.scaleWidth * 0.9,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _activeStepIndex,
              steps: stepList(regViewModel: regViewModel),
              onStepContinue: () {
                if (_activeStepIndex < (stepList().length - 1)) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                } else {
                  regViewModel.registerDriver(
                      userId: '5ee04f51-0692-48bb-bcbf-de3d88b90dd7',
                      cnicFront: cnicFrontUrl ?? '',
                      cnicBack: 'cnicBack',
                      licenseFront: 'licenseFront',
                      licenseBack: 'licenseBack',
                      vehicleType: vType.text,
                      vehicleBrand: vBrand.text,
                      vehicleModel: vModel.text,
                      vehicleColor: vColor.text,
                      vehiclePhoto: 'vehiclePhoto',
                      vehicleRegImage: 'vehicleRegImage',
                      vehicleRegNo: vregNo.text);
                  // widget.onCloseTap();
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
                setState(() {
                  _activeStepIndex = index;
                });
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = _activeStepIndex == stepList().length - 1;
                return StepControlBuilder(
                    viewModel: regViewModel,
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
  Future<String> uploadImage(filename, url) async {
    debugPrint(filename);
    debugPrint(url);
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.100.228:3001/file'));

    debugPrint('FILE');
    debugPrint(request.files.toString());
    debugPrint(request.fields.toString());
    debugPrint('FILE sending');
    var res = await request.send();

    debugPrint(res.toString());
    debugPrint(res.reasonPhrase.toString());
    return res.reasonPhrase!;
  }

  String state = "";

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
        validator: widget.validator,
        builder: (formFieldState) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? imageFile;
                  imageFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  var res = await uploadImage(imageFile?.path, imageFile?.name);
                  setState(() {
                    state = res;
                    print(res);
                  });
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
                        const Icon(Icons.image_outlined,
                            size: 36, color: AppColors.PRIMARY_500),
                        Text(
                          widget.label,
                          textAlign: TextAlign.center,
                        ),
                        !isPicking
                            ? const Icon(Icons.check_outlined,
                                size: 21, color: AppColors.FONT_GRAY)
                            : const Icon(Icons.check,
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
    required RegistrationViewModel viewModel,
    required this.isLastStep,
  })  : _activeStepIndex = activeStepIndex,
        _viewModel = viewModel,
        _details = details;

  final int _activeStepIndex;
  final ControlsDetails _details;
  final RegistrationViewModel _viewModel;
  final bool isLastStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
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
            child: isLastStep
                ? LoginButton(
                    text: 'Submit',
                    isLoading: _viewModel.registerDriverResource.ops ==
                        NetworkStatus.LOADING,
                    onPress: _details.onStepContinue,
                  )
                : ElevatedButton(
                    onPressed: _details.onStepContinue,
                    child: (isLastStep)
                        ? LoginButton(
                            text: 'Submit',
                            isLoading: _viewModel.registerDriverResource.ops ==
                                NetworkStatus.LOADING,
                          )
                        : Text('Next',
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
  }
}
