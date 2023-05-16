import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:hop_on/core/profile/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';

class RiderDetailCard extends StatefulWidget {
  const RiderDetailCard({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<RiderDetailCard> {
  final SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel pViewModel = context.watch<ProfileViewModel>();
    return SizedBox(
      height: config.uiWidthPx * 0.92,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
            width: config.uiWidthPx * 0.96,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200, boxShadow: [
              const BoxShadow(
                blurRadius: 10,
                offset: Offset.zero,
                color: Colors.white,
              ),
              BoxShadow(blurRadius: 6, offset: Offset.zero, color: Colors.grey.shade400)
            ]),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pViewModel.getProfileResource.ops == NetworkStatus.LOADING)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgressIndicator()],
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  else
                    const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("First Name"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pViewModel.firstName,
                          style: const TextStyle(
                            color: AppColors.FONT_GRAY,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("last Name"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pViewModel.lastName,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: AppColors.FONT_GRAY,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("Email"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pViewModel.email,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: AppColors.FONT_GRAY,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("Phone number"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pViewModel.phone,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: AppColors.FONT_GRAY,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("Gender"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pViewModel.gender,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                              color: AppColors.FONT_GRAY,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("City"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pViewModel.currentCity,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                              color: AppColors.FONT_GRAY,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("Locale"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: config.uiWidthPx * 0.9,
                    height: config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pViewModel.locale,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                              color: AppColors.FONT_GRAY,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )),
      ),
    );
  }
}
