import 'package:flutter/material.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class EndRideModal extends StatefulWidget {
  final Function() onRideEnded;

  const EndRideModal({Key? key, required this.onRideEnded}) : super(key: key);

  @override
  EndRideModalState createState() => EndRideModalState();
}

class EndRideModalState extends State<EndRideModal> {
  final SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: config.uiWidthPx * 0.3,
      child: const LoginButton(
        text: "End Ride",
        isLoading: false,
      ).ripple(
        () {
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.only(top: 7),
                height: config.uiHeightPx / 1.5,
                width: config.uiWidthPx * 1,
                decoration: const BoxDecoration(
                  color: AppColors.LM_BACKGROUND_BASIC,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 2.875,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(80)),
                            color: AppColors.PRIMARY_500.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
