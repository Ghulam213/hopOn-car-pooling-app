import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class EditProfileTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? Function(String?) validator;
  final String hintText;
  final int? maxLines;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final bool? isObscured;
  final TextInputType? keyBoardType;
  final TextDirection? textDirection;

  const EditProfileTextField(
      {Key? key,
      required this.textEditingController,
      required this.validator,
      required this.hintText,
      this.suffixIcon,
      this.fillColor,
      this.borderColor,
      this.isObscured,
      this.keyBoardType,
      this.textDirection,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      obscureText: isObscured ?? false,
      keyboardType: keyBoardType,
      textDirection: textDirection,
      validator: (value) => validator(value),
      controller: textEditingController,
      style: const TextStyle(
        color: AppColors.LM_FONT_PRIMARY_GREY9,
        fontSize: 14,
      ),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          fillColor: fillColor ?? Colors.white,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: const TextStyle(
            color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
            fontSize: 14,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? AppColors.LM_FONT_BLOCKTEXT_GREY7,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.red1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.LM_FONT_BLOCKTEXT_GREY7.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.red1),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.PRIMARY_300,
            ),
            borderRadius: BorderRadius.circular(5),
          )),
    );
  }
}
