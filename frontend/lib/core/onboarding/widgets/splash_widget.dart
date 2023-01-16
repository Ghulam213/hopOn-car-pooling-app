import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';
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
                  child: Center(child: Text('Welcome')),
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
                    children: const [
                      Text(
                        "By",
                        style: TextStyle(
                            color: AppColors.LM_FONT_SECONDARY_GREY8,
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "By",
                        style: TextStyle(
                            color: AppColors.LM_FONT_SECONDARY_GREY8,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
