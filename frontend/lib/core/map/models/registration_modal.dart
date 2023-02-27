import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/core/profile/modals/vehicle_info_modal.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../profile/modals/driver_info_modal.dart';
import '../../widgets/custom_toast.dart';

class RegistrationModal extends StatefulWidget {
  // final Datum data;
  // final Function() onStatusChangedCompleted;

  final Function() onCloseTap;
  final Function(String) onErrorOccurred;

  RegistrationModal(
      {Key? key,
      // required this.onStatusChangedCompleted,
      required this.onCloseTap,
      required this.onErrorOccurred})
      : super(key: key);

  @override
  _ReferenceNumberBottomSheetState createState() =>
      _ReferenceNumberBottomSheetState();
}

class _ReferenceNumberBottomSheetState extends State<RegistrationModal> {
  final TextEditingController _searchController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final SizeConfig _config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      initialChildSize: 0.95,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          color: AppColors.LM_BACKGROUND_BASIC,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _config.sh(120).toDouble(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Text(
                  tr("Please fill in the required information"),
                  style: const TextStyle(
                      color: AppColors.FONT_GRAY,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // Form(
              //   key: _formKey,
              //   child: Card(
              //     elevation: 2,
              //     margin: const EdgeInsets.symmetric(horizontal: 13.0),
              //     child: SizedBox(
              //       width: SizeConfig.screenWidthDp!,
              //       child: Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: TextFormField(
              //           textInputAction: TextInputAction.done,
              //           keyboardType: TextInputType.datetime,
              //           onChanged: (String? value) {},
              //           onEditingComplete: () {
              //             FocusScope.of(context).unfocus();
              //           },
              //           controller: _searchController,
              //           validator: (String? value) {
              //             if (value == null) {
              //               return tr(
              //                       "Please provide the reference number of this order in your system")
              //                   .toString();
              //             }

              //             if (value.isEmpty) {
              //               return tr(
              //                       "Please provide the reference number of this order in your system")
              //                   .toString();
              //             }

              //             return null;
              //           },
              //           decoration: InputDecoration(
              //             border: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             errorBorder: InputBorder.none,
              //             hintText: tr("Reference number"),
              //             hintStyle: Theme.of(context)
              //                 .textTheme
              //                 .bodyText2!
              //                 .copyWith(fontSize: 15, height: 1.5),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        builder: (context) {
                          return DriverInfoModal(
                            // data: data,
                            onErrorOccurred: (error) {
                              customToastBlack(
                                  msg: "Error while updating order: $error");
                            },
                            onCloseTap: () {
                              Navigator.of(_scaffoldKey.currentContext!).pop();
                            },
                          );
                        });
                  },
                  child: Card(
                    child: Container(
                      width: SizeConfig.screenWidthDp,
                      height: _config.sh(40).toDouble(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                            colors: AppColors.GRADIENTS,
                            stops: [
                              0.1,
                              0.9,
                            ]),
                      ),
                      child: Center(
                        child: Text(
                          tr("Driver Info"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 48,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        builder: (context) {
                          return VehicleInfoModal(
                            // data: data,
                            onErrorOccurred: (error) {
                              customToastBlack(
                                  msg: "Error while updating order: $error");
                            },
                            onCloseTap: () {
                              Navigator.of(_scaffoldKey.currentContext!).pop();
                            },
                          );
                        });
                  },
                  child: Card(
                    child: Container(
                      width: SizeConfig.screenWidthDp,
                      height: _config.sh(40).toDouble(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                          colors: AppColors.GRADIENTS,
                          stops: [
                            0.1,
                            0.9,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tr("Vehicle Info"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
