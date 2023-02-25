import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/core/widgets/divider.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class DriverInfoModal extends StatefulWidget {
  // final Datum data;
  // final Function() onStatusChangedCompleted;

  final Function() onCloseTap;
  final Function(String) onErrorOccurred;

  const DriverInfoModal(
      {Key? key, required this.onCloseTap, required this.onErrorOccurred})
      : super(key: key);

  @override
  _DriverInfoModalState createState() => _DriverInfoModalState();
}

class _DriverInfoModalState extends State<DriverInfoModal> {
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final SizeConfig _config = SizeConfig();

  @override
  void initState() {
    super.initState();
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
          child: Column(
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
                      const SizedBox(height: 40),
                      SizedBox(
                        width: _config.uiWidthPx * 0.65,
                        child: ElevatedButton(
                          child: Text('Continue',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      color: AppColors.LM_BACKGROUND_BASIC)),
                          onPressed: () {
                            var formValid =
                                _formKey.currentState?.validate() ?? false;

                            if (formValid) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
