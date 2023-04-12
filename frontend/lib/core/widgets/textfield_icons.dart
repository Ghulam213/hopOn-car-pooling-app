import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/Utils/image_path.dart';

import '../../Utils/colors.dart';

class PrefixIcon2 extends StatelessWidget {
  const PrefixIcon2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SvgPicture.asset(
        ImagesAsset.locate,
        colorFilter:
            const ColorFilter.mode(AppColors.PRIMARY_500, BlendMode.srcIn),
        height: 10,
        width: 10,
      ),
    );
  }
}

class SuffixNow1 extends StatelessWidget {
  const SuffixNow1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Container(
          height: 25,
          width: 60,
          decoration: const BoxDecoration(
              color: AppColors.PRIMARY_500,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 13.0,
                color: Colors.white,
              ),
              Text("Now",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
            ],
          )).ripple(() {}),
    );
  }
}

class PrefixIcon1 extends StatelessWidget {
  PrefixIcon1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(ImagesAsset.car,
          colorFilter:
              const ColorFilter.mode(AppColors.PRIMARY_500, BlendMode.srcIn),
          height: 15,
          width: 15),
    );
  }
}
