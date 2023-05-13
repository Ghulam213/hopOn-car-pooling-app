import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

buildPassengerLocation(BuildContext context) {
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return const PassengerLocationModal();
      });
}

class PassengerLocationModal extends StatefulWidget {
  const PassengerLocationModal({
    Key? key,
  }) : super(key: key);

  @override
  _PassengerLocationModalState createState() => _PassengerLocationModalState();
}

class _PassengerLocationModalState extends State<PassengerLocationModal> {
  final SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7),
      height: config.uiHeightPx / 1.5,
      width: config.uiWidthPx * 1,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
              width: 80,
              height: 2.875,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(80)),
                color: AppColors.PRIMARY_500.withOpacity(0.5),
              )),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
