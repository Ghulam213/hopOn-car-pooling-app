import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class RegistrationModal extends StatefulWidget {
  // final Datum data;
  // final Function() onStatusChangedCompleted;
  // final Function(String) onErrorOccurred;

  const RegistrationModal({
    Key? key,
    // required this.onStatusChangedCompleted,
    // required this.onErrorOccurred
  }) : super(key: key);

  @override
  _ReferenceNumberBottomSheetState createState() =>
      _ReferenceNumberBottomSheetState();
}

class _ReferenceNumberBottomSheetState extends State<RegistrationModal> {
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final SizeConfig _config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final OrderViewModel orderViewModel = context.watch<OrderViewModel>();
    // Amplitude.getInstance()
    //     .logEvent('Refrence number dialog bottomsheet started');

    return DraggableScrollableSheet(
      maxChildSize: 0.75,
      minChildSize: 0.5,
      expand: false,
      initialChildSize: 0.7,
      builder: (BuildContext context, ScrollController controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Text(
                tr("Please input the reference number of this order"),
                style: const TextStyle(
                    color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
              key: _formKey,
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 13.0),
                child: SizedBox(
                  width: SizeConfig.screenWidthDp!,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.datetime,
                      onChanged: (String? value) {},
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      controller: _searchController,
                      validator: (String? value) {
                        if (value == null) {
                          return tr(
                                  "Please provide the reference number of this order in your system")
                              .toString();
                        }

                        if (value.isEmpty) {
                          return tr(
                                  "Please provide the reference number of this order in your system")
                              .toString();
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintText: tr("Reference number"),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {}
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
                        tr("Confirm"),
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
        );
      },
    );
  }

  Future<void> _updateOrderStatus(String status) async {
    // final OrderViewModel orderViewModel = context.read<OrderViewModel>();

    // await orderViewModel.updateOrderStatus(widget.data.id!.toString(), status,
    //     referenceNumber: _searchController.text);
    // if (orderViewModel.updateOrderStatusResource.ops == NetworkStatus.FAILED) {
    //   //Error while trying to update order
    //   customToastBlack(
    //     msg: tr("order_has_been_changed"),
    //   );
    //   widget.onErrorOccurred(
    //       orderViewModel.updateOrderStatusResource.networkError!);
    // } else {
    //   //Status Change is successful
    //   log("Status change is successful");
    //   widget.onStatusChangedCompleted();
    // }
  }
}
