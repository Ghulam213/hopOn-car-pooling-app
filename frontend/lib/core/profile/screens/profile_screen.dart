import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../widgets/rider_details.dart';
import 'edit_rider_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  // final Function onDrawerTapped;
  // final Function onEditTapped;
  // final Function onEditComplete;

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        leading: InkWell(
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 30),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ImagesAsset.driverpic))),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text('Personal Information',
                          style: TextStyle(
                              color: AppColors.PRIMARY_500,
                              fontSize: 22,
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
                      const RiderDetailCard(),
                      Container(
                        decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 12,
                        ),
                        child: InkWell(
                          onTap: () {
                            onEditTapped();
                          },
                          child: Card(
                              color: pViewModel.updateProfileResource.ops ==
                                      NetworkStatus.LOADING
                                  ? AppColors.LM_BACKGROUND_BASIC
                                  : AppColors.PRIMARY_500.withOpacity(0.90),
                              child: SizedBox(
                                  width: SizeConfig.screenWidthDp! * 0.65,
                                  height: config.sh(40).toDouble(),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        easy.tr("Edit"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ))),
                        ),
                      ),
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
