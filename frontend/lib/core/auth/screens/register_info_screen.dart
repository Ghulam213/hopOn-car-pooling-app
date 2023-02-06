import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';

import 'package:hop_on/config/sizeconfig/size_config.dart';

class RegisterInfoScreen extends StatefulWidget {
  static const routeName = '/phoneAuth';

  const RegisterInfoScreen({Key? key}) : super(key: key);

  @override
  _RegisterInfoScreenState createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final SizeConfig _config = SizeConfig();
  TextEditingController dateController = TextEditingController();
  String city = 'Islamabad';
  String gender = 'Male';

  @override
  void initState() {
    super.initState();
  }

  void dismissFocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      labelText: 'city',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.green1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.PRIMARY_500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.PRIMARY_700),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.LM_FONT_ERROR_RED6),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                    height: (MediaQuery.of(context).viewInsets.bottom > 0.0)
                        ? (_config.uiHeightPx * 0.05).toDouble()
                        : (_config.uiHeightPx * 0.10).toDouble()),
                Container(
                  padding: const EdgeInsets.all(15),
                  // height: 150,
                  child: Center(
                      child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date"),
                    readOnly: true,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16, height: 1.0, color: AppColors.FONT_GRAY),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      } else {
                        debugPrint("Date is not selected");
                      }
                    },
                  )),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: city,
                  elevation: 16,
                  icon: const Icon(Icons.arrow_drop_down),
                  isDense: true,
                  decoration: inputDecoration,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'no city selected';
                    }
                  },
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        city = newValue;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Islamabad',
                      child: Text('Islamabad'),
                    ),
                    DropdownMenuItem(
                      value: 'Rawalpindi',
                      child: Text('Rawalpindi'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: gender,
                  elevation: 16,
                  icon: const Icon(Icons.arrow_drop_down),
                  isDense: true,
                  decoration: inputDecoration,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'no gender selected';
                    }
                  },
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        gender = newValue;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text('Other'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomImageFormField(
                  validator: (val) {
                    if (val == null) return 'Pick a picture';
                  },
                  onChanged: (_file) {},
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: _config.uiWidthPx * 0.65,
                  child: ElevatedButton(
                    child: Text('Save',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            color: AppColors.LM_BACKGROUND_BASIC)),
                    onPressed: () {
                      var formValid = formKey.currentState?.validate() ?? false;
                      var message = 'Form isn\'t valid';
                      if (formValid) {
                        message = 'Form is valid: ${controller.text}';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 16,
                                      height: 1.0,
                                      color: AppColors.FONT_GRAY)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomImageFormField extends StatelessWidget {
  CustomImageFormField({
    Key? key,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);
  final String? Function(File?) validator;
  final Function(File) onChanged;
  File? _pickedFile;
  @override
  Widget build(BuildContext context) {
    return FormField<File>(
        validator: validator,
        builder: (formFieldState) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  FilePickerResult? file = await FilePicker.platform.pickFiles(
                      dialogTitle: 'Select a profile photo',
                      type: FileType.image,
                      allowMultiple: false);
                  if (file != null) {
                    _pickedFile = File(file.files.first.path!);
                    onChanged.call(_pickedFile!);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.FONT_GRAY.withOpacity(0.1),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.upload_file),
                      Text('Select a profile photo')
                    ],
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
