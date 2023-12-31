import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../widgets/profile_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final Function onUpdateSuccess;
  final Function(String) onUpdateFailed;
  final String? countryCode;

  const EditProfileScreen({Key? key, required this.onUpdateFailed, required this.onUpdateSuccess, this.countryCode})
      : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final SizeConfig config = SizeConfig();

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _localeController = TextEditingController();

  String fullCode = '';

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    _fNameController.text = profileViewModel.firstName;
    _lNameController.text = profileViewModel.lastName;
    _phoneController.text = profileViewModel.phone;
    _genderController.text = profileViewModel.gender;
    _cityController.text = profileViewModel.currentCity;
    _localeController.text = profileViewModel.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidthDp,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(
              height: config.uiHeightPx * 0.5,
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
                      height: config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _fNameController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input first name");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: config.sh(10).toDouble(),
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
                      height: config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _lNameController,
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
                      height: config.sh(10).toDouble(),
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
                      height: config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _phoneController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input first name");
                          }
                          return null;
                        },
                        hintText: ''),
                    const SizedBox(
                      height: 10,
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
                      height: config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _genderController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your gender");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("City"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _cityController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your city");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: config.sh(10).toDouble(),
                    ),
                    Text(
                      easy.tr("Locale"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: config.sh(5).toDouble(),
                    ),
                    EditProfileTextField(
                        textEditingController: _localeController,
                        textDirection: TextDirection.ltr,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("Please input your locale");
                          }
                          return null;
                        },
                        hintText: ''),
                    SizedBox(
                      height: config.sh(10).toDouble(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: config.sh(4).toDouble()),
            // InkWell(
            //   onTap: () {
            //     updateProfile(); // TO DO remove
            //     if (true
            //         profileViewModel.updateProfileResource.ops !=
            //             NetworkLOADINGStatus.
            //         ) {
            //       if (_formKey.currentState!.validate() &&
            //           _numberController.text.isNotEmpty) {
            //         updateProfile();
            //       }
            //     }
            //   },
            // child: Card(
            //     color: false
            //         profileViewModel.updateProfileResource.ops ==
            //                 NetworkStatus.LOADING
            //         ? AppColors.LM_BACKGROUND_BASIC
            //         : AppColors.PRIMARY_300,
            //     child: SizedBox(
            //         width: SizeConfig.screenWidthDp,
            //         height: config.sh(40).toDouble(),
            //         child: Center(
            //           child: Text(
            //             easy.tr("Save"),
            //             style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 17,
            //                 fontWeight: FontWeight.w700),
            //           ),
            //         ))),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final String fName = _fNameController.text;
    final String lName = _lNameController.text;
    final String phone = _phoneController.text;
    final String gender = _genderController.text;
    final String city = _cityController.text;
    final String locale = _localeController.text;

    await profileViewModel.updateProfile(
      firstName: fName,
      lastName: lName,
      gender: gender,
      phone: phone,
      currentCity: city,
      locale: locale,
    );

    if (profileViewModel.updateProfileResource.ops == NetworkStatus.SUCCESSFUL) {
      widget.onUpdateSuccess();
    } else {
      widget.onUpdateFailed(profileViewModel.updateProfileResource.networkError!);
    }
  }
}
