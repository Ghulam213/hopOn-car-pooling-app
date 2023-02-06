import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:flutter_svg/svg.dart';
import '../../../config/sizeconfig/size_config.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeightDp,
        width: SizeConfig.screenWidthDp,
        color: Colors.white,
        child: Stack(
          children: [
            SizedBox(
              height: SizeConfig.screenHeightDp,
              width: SizeConfig.screenWidthDp,
              child: Center(
                child: SizedBox(
                  width: SizeConfig.screenWidthDp! - 120,
                  height: SizeConfig().sh(100).toDouble(),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      width: SizeConfig.screenWidthDp! - 120,
                      height: SizeConfig().sh(100).toDouble(),
                        color: AppColors.PRIMARY_500
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
                right: 0,
                left: 0,
                bottom: 50,
                child: SizedBox(
                  width: SizeConfig.screenWidthDp,
                  height: SizeConfig().sh(100).toDouble(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                      // Text(
                      //   context.locale.toString() == 'en' ? "en" : "ur",
                      //   style: const TextStyle(
                      //       color: AppColors.LM_FONT_SECONDARY_GREY8,
                      //       fontSize: 15),
                      // ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
