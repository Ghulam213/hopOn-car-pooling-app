import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../auth/widgets/country_picker.dart';
import '../widgets/profile_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final Function onUpdateSuccess;
  final Function(String) onUpdateFailed;
  final String? countryCode;

  const EditProfileScreen(
      {Key? key,
      required this.onUpdateFailed,
      required this.onUpdateSuccess,
      this.countryCode})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final SizeConfig _config = SizeConfig();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String fullCode = '';

  final GlobalKey<FormState> _formKey = GlobalKey();

  // Future<PhoneNumber> _parsePhoneNumber() async {
  // final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
  // try {
  // final PhoneNumber phoneNumber =
  //     await PhoneNumberUtil().parse('profileViewModel.phone');
  // _numberController.text = phoneNumber.nationalNumber;
  // fullCode = phoneNumber.countryCode + phoneNumber.nationalNumber;

  // return await Future<PhoneNumber>.delayed(Duration(seconds: 2));
  // } catch (e) {
  //   // _numberController.text = profileViewModel.phone;
  //   log("Parse error: $e");
  //   throw e.toString();
  // }
  // }

  @override
  void initState() {
    super.initState();
    // final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    // _emailController.text = profileViewModel.email;
    // _nameController.text = profileViewModel.name;
    // fullCode = profileViewModel.phone;
  }

  @override
  Widget build(BuildContext context) {
    // final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();

    return Container(
      width: SizeConfig.screenWidthDp,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(
              height: _config.uiHeightPx * 0.6,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      easy.tr("First Name"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _nameController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input first name");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: _config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("Last Name"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _emailController,
                        textDirection: TextDirection.ltr,
                        keyBoardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your last name");
                          }
                          // else if (!ProfileUtils.isValidEmailAddress(value)) {
                          //   return easy.tr("Please input a valid email address");
                          // }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: _config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("Phone"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    SizedBox(child: FutureBuilder(
                      // future: _parsePhoneNumber(),
                      builder: (BuildContext context,
                          AsyncSnapshot<PhoneNumber> snapshot) {
                        if (snapshot.hasData) {
                          return Directionality(
                            textDirection: TextDirection.ltr,
                            child: ContactInputField(
                              (contact, code, _) {
                                fullCode = code! + contact;
                              },
                              () => {},
                              false,
                              false,
                              _numberController,
                              initialCountryCode:
                                  '+${snapshot.data!.countryCode}',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Please input your phone";
                                }
                                return null;
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Directionality(
                            textDirection: TextDirection.ltr,
                            child: ContactInputField(
                              (contact, code, _) {
                                fullCode = code! + contact;
                              },
                              () => {},
                              false,
                              false,
                              _numberController,
                              validator: (String? value) {
                                if (value == null) {
                                  return "Please input your phone";
                                } else if (value.isEmpty) {
                                  return "Please input your phone";
                                }
                                return null;
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      easy.tr("Email"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _nameController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your email");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: _config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("Password"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _nameController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your passwrd");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: _config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("Gender"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _nameController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your gender");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: _config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("Age"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: _config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _nameController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your name");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(height: _config.sh(10).toDouble()),
                  ],
                ),
              ),
            ),
            SizedBox(height: _config.sh(4).toDouble()),
            InkWell(
              onTap: () {
                updateProfile(); // TO DO remove
                if (true
                    // profileViewModel.updateProfileResource.ops !=
                    //     NetworkStatus.LOADING
                    ) {
                  if (_formKey.currentState!.validate() &&
                      _numberController.text.isNotEmpty) {
                    updateProfile();
                  }
                }
              },
              child: Card(
                  color: false
                      // profileViewModel.updateProfileResource.ops ==
                      //         NetworkStatus.LOADING
                      ? AppColors.LM_BACKGROUND_BASIC
                      : AppColors.PRIMARY_300,
                  child: SizedBox(
                      width: SizeConfig.screenWidthDp,
                      height: _config.sh(40).toDouble(),
                      child: Center(
                        child: Text(
                          easy.tr("Save"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    // final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final String name = _nameController.text;
    final String email = _emailController.text;

    // await profileViewModel.updateProfile(
    //     profileID: profileViewModel.id,
    //     fullName: name,
    //     emailAddress: email,
    //     phoneNumber: fullCode);

    if (true
        // profileViewModel.updateProfileResource.ops ==NetworkStatus.SUCCESSFUL
        ) {
      widget.onUpdateSuccess();
    } else {
      // widget
      //     .onUpdateFailed(profileViewModel.updateProfileResource.networkError!);
    }
  }
}
