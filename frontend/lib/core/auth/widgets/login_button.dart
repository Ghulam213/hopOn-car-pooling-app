import 'package:flutter/material.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import '../../../Utils/colors.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  final Color? color;
  final bool? isLoading;

  const LoginButton(
      {this.text = '', this.onPress, this.color, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress?.call();
      },
      child: Card(
        color: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          width: SizeConfig.screenWidthDp,
          height: SizeConfig().sh(40).toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: AppColors.GRADIENTS_MAIN_900,
              stops: [
                0.1,
                0.9,
              ],
            ),
          ),
          child: Center(
            child: isLoading!
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
          ),
        ),
      ),
    );
  }
}
