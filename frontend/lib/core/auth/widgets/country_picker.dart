import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';

class ContactInputField extends StatefulWidget {
  final Function(String val, String? code, bool status) onChanged;
  final Function doWeExecuteAction;
  final bool isSuccess;
  final bool isFailure;
  final TextEditingController controller;
  final String? initialCountryCode;
  final String? Function(String?)? validator;

  const ContactInputField(this.onChanged, this.doWeExecuteAction,
      this.isSuccess, this.isFailure, this.controller,
      {this.initialCountryCode, this.validator});

  @override
  _ContactInputFieldState createState() => _ContactInputFieldState();
}

class _ContactInputFieldState extends State<ContactInputField> {
  late String codeString;

  @override
  void initState() {
    super.initState();
    codeString = widget.initialCountryCode ?? '+92';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          SizedBox(
            width: SizeConfig.screenWidthDp,
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: TextFormField(
                    controller: widget.controller,
                    validator: widget.validator,
                    textDirection: TextDirection.ltr,
                    onChanged: (value) {
                      if (value.length > (codeString == '+966' ? 8 : 9)) {
                        widget.onChanged(value, codeString, true);
                      } else {
                        widget.onChanged(value, codeString, false);
                      }
                    },
                    keyboardType: TextInputType.number,
                    cursorColor: AppColors.PRIMARY_500,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15, height: 1.0, color: AppColors.grey1),
                    textAlignVertical: TextAlignVertical.top,
                    maxLength: codeString == '+92' ? 9 : 10,
                    decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.only(
                          left: 150,
                          top: 30,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: const TextStyle(
                          color: AppColors.grey1,
                          fontSize: 14,
                        ),
                        hintText: "",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.grey1,
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
                              color: AppColors.LM_FONT_BLOCKTEXT_GREY7
                                  .withOpacity(0.5)),
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
                            color: AppColors.BLUE,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        )))),
          ),
          SizedBox(
            width: 160,
            height: 50,
            child: Row(
              children: [
                SizedBox(
                  child: CountryListPick(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.LM_BACKGROUND_GREY1),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      backgroundColor: AppColors.BLUE,
                      title: Text(
                        'Pick your country',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14, color: AppColors.LM_BACKGROUND_GREY1),
                      ),
                    ),
                   
                    pickerBuilder: (context, CountryCode? countryCode) {
                      return SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.60,
                              child: SizedBox(
                                child: Image.asset(
                                  countryCode!.flagUri!,
                                  package: 'country_list_pick',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              countryCode.dialCode!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 15,
                                      height: 1.0,
                                      color: AppColors.LM_FONT_PRIMARY_GREY10),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 16,
                              color: AppColors.LM_FONT_PRIMARY_GREY10,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 2,
                              color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                            )
                          ],
                        ),
                      );
                    },
                    theme: CountryTheme(
                      labelColor: AppColors.BLACK,
                      alphabetTextColor: AppColors.BLACK,
                      alphabetSelectedBackgroundColor: AppColors.BLUE,
                      isShowFlag: true,
                      isShowTitle: false,
                      isShowCode: true,
                      isDownIcon: true,
                      showEnglishName: false,
                    ),
                    initialSelection: codeString,
                    onChanged: (code) {
                      setState(() {
                        codeString = code!.dialCode!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
