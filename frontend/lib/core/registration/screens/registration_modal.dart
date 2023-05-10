import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/core/registration/screens/vehicle_info_modal.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/custom_toast.dart';

class RegistrationModal extends StatefulWidget {


  final Function()? onCloseTap;
  final Function(String)? onErrorOccurred;

  const RegistrationModal(
      {Key? key,
       this.onCloseTap, this.onErrorOccurred})
      : super(key: key);

  @override
  ReferenceNumberBottomSheetState createState() =>
      ReferenceNumberBottomSheetState();
}

class ReferenceNumberBottomSheetState extends State<RegistrationModal> {
  final TextEditingController _searchController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.65,
      minChildSize: 0.5,
      expand: false,
      initialChildSize: 0.65,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          color: AppColors.LM_BACKGROUND_BASIC,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: config.sh(120).toDouble(),
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
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          );
                        });
                  },
                  child: Card(
                    child: Container(
                      width: SizeConfig.screenWidthDp,
                      height: config.sh(40).toDouble(),
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
