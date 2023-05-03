import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class RiderDetailCard extends StatefulWidget {
  const RiderDetailCard({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<RiderDetailCard> {
  final SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.PRIMARY_500.withOpacity(0.90),
      child: SizedBox(
        height: config.uiWidthPx * 0.92,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
              width: config.uiWidthPx * 0.96,
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
                      const SizedBox(height: 10),
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
                      width: config.uiWidthPx * 0.9,
                      height: config.sh(30).toDouble(),
                      padding: const EdgeInsets.all(8.0),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Umer',
                            style: TextStyle(
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
                      width: config.uiWidthPx * 0.9,
                      height: config.sh(30).toDouble(),
                      decoration: BoxDecoration(
                        color: AppColors.LM_BACKGROUND_BASIC,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Zia',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
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
                      width: config.uiWidthPx * 0.9,
                      height: config.sh(30).toDouble(),
                      decoration: BoxDecoration(
                        color: AppColors.LM_BACKGROUND_BASIC,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'mzia.bese19seecs@seecs.edu.pk',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
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
                      width: config.uiWidthPx * 0.9,
                      height: config.sh(30).toDouble(),
                      decoration: BoxDecoration(
                        color: AppColors.LM_BACKGROUND_BASIC,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '+923360555666',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
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
                      width: config.uiWidthPx * 0.9,
                      height: config.sh(30).toDouble(),
                      decoration: BoxDecoration(
                        color: AppColors.LM_BACKGROUND_BASIC,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Male',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
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
                      width: config.uiWidthPx * 0.9,
                      height: config.sh(30).toDouble(),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '23',
                            style: TextStyle(
                              color: AppColors.FONT_GRAY,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
