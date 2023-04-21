import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/colors.dart';
import '../../config/sizeconfig/size_config.dart';

class CustomPlaceTextWidget extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final Widget? prefix;
  final String hintText;
  final SizeConfig config;
  final TextEditingController controlelr;

  CustomPlaceTextWidget(
      {this.onSubmitted,
      this.suffix,
      this.prefix,
      required this.hintText,
      required this.config,
      required this.controlelr,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      height: 55,
      width: config.uiWidthPx - 60,
      child: TextField(
        scrollPadding: const EdgeInsets.symmetric(vertical: 15),
        onSubmitted: onSubmitted,
        readOnly: false,
        controller: controlelr,
        cursorColor: AppColors.FONT_GRAY,
        keyboardType: TextInputType.streetAddress,
        autofillHints: const [AutofillHints.addressCity],
        style: GoogleFonts.montserrat(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: AppColors.PRIMARY_500.withOpacity(0.8),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: prefix ?? prefix,
          filled: true,
          fillColor: AppColors.PRIMARY_500.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.PRIMARY_500,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppColors.PRIMARY_500),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.PRIMARY_500.withOpacity(0.9),
              ),
        ),
      ),
    );
  }
}