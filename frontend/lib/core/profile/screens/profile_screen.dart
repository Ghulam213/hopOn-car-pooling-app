import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../widgets/dropdown_selector.dart';
import '../widgets/rider_details.dart';
import 'edit_rider_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final PageController pageController = PageController();
  final SizeConfig config = SizeConfig();
  bool isEditing = false;

  void onEditTapped() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel pViewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.LM_BACKGROUND_BASIC,
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_500,
        elevation: 2,
        leadingWidth: config.sw(100).toDouble(),
        actions: [
          InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MapScreen()),
            );
          },
            child: const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.LM_BACKGROUND_BASIC,
              size: 26.0,
            ),
          ),
          ),
          const Spacer(),
          SizedBox(
            child: IconButton(
              onPressed: () {
                onEditTapped();
              },
              iconSize: 20,
              icon: const Icon(
                Icons.edit,
                size: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
       
    
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/wave.svg",
                  width: SizeConfig.screenWidthDp!,
                ),
                const SizedBox(
                  height: 5,
                ),

                
                const SizedBox(
                  height: 5,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Image.asset(
                        ImagesAsset.driverpic,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text('Preferences',
                          style: TextStyle(
                              color: AppColors.PRIMARY_500,
                              fontSize: 16,
                              fontWeight: FontWeight.w700))),
                ),
                SizedBox(
                  height: config.uiHeightPx * 0.08,
                  width: config.uiWidthPx * 0.8,
                  child: GenderSelector(
                    selectedGender: pViewModel.passengerGenderPreference,
                    onChanged: (val) {
                      setState(() {
                        pViewModel.passengerGenderPreference = val;
                      });
                      pViewModel.setPassengerPrefs(
                          genderPreference: val.toUpperCase());
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text('Personal Information',
                          style: TextStyle(
                              color: AppColors.PRIMARY_500,
                              fontSize: 18,
                              fontWeight: FontWeight.w700))),
                ),
                if (isEditing)
                  EditProfileScreen(
                    countryCode: '+92',
                    onUpdateFailed: (String error) {
                      // customToastBlack(
                      //   msg: error,
                      // );
                    },
                    onUpdateSuccess: () {
                      onEditTapped();
                      // customToastBlack(
                      //     msg: easy.tr("Profile Update successful"));
                    },
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                          height: SizeConfig.screenHeightDp! * 0.55,
                          child: const RiderDetailCard()),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
