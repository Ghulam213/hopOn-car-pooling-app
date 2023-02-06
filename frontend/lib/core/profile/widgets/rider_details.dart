import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class RiderDetailCard extends StatefulWidget {
  const RiderDetailCard({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<RiderDetailCard> {
  final SizeConfig _config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _config.uiWidthPx * 0.92,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
            width: _config.uiWidthPx * 0.96,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 10,
                    offset: Offset.zero,
                    color: Colors.white,
                  ),
                  BoxShadow(
                      blurRadius: 6,
                      offset: Offset.zero,
                      color: Colors.grey.shade400)
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (false)
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
                    SizedBox(height: 10),
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
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'first name',
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
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'last name',
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
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'email',
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
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'phone number',
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
                      easy.tr("Password"),
                      style: const TextStyle(
                        color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.LM_BACKGROUND_BASIC,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'password',
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
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
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
                            'gender',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      easy.tr("Age"),
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
                    width: _config.uiWidthPx * 0.9,
                    height: _config.sh(30).toDouble(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'age',
                          style: const TextStyle(
                            color: AppColors.FONT_GRAY,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
