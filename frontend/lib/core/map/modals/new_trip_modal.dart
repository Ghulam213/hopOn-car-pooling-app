import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class NewTripModal extends StatefulWidget {
  final Function() onCloseTap;
  final Function(String) onErrorOccurred;

  NewTripModal(
      {Key? key, required this.onCloseTap, required this.onErrorOccurred})
      : super(key: key);

  @override
  _VehicleInfoModalState createState() => _VehicleInfoModalState();
}

class _VehicleInfoModalState extends State<NewTripModal> {
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SizeConfig _config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  int _activeStepIndex = 0;

  String status = 'accepted';
  String durationString = '';
  bool isRequestingDirection = false;
  String buttonTitle = 'ARRIVED';

  Color buttonColor = AppColors.green1;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              spreadRadius: 0.5,
              offset: Offset(
                0.7,
                0.7,
              ),
            )
          ],
        ),
        height: 270,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                durationString,
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Brand-Bold',
                    color: AppColors.PRIMARY_300),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    'RiderName',
                    style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.call),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/pickicon.png',
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'PickupAddress',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/desticon.png',
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'DestinationAddress',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              TextButton(
                child: Text('buttonTitle',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: AppColors.LM_BACKGROUND_BASIC)),
                onPressed: () async {
                  if (status == 'accepted') {
                    status = 'arrived';
                    // rideRef.child('status').set(('arrived'));

                    setState(() {
                      buttonTitle = 'START TRIP';
                      buttonColor = AppColors.PRIMARY_300;
                    });

                    // HelperMethods.showProgressDialog(context);

                    // await getDirection(widget.tripDetails.pickup,
                    //     widget.tripDetails.destination);

                    Navigator.pop(context);
                  } else if (status == 'arrived') {
                    status = 'ontrip';

                    setState(() {
                      buttonTitle = 'END TRIP';
                      buttonColor = AppColors.red1;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
