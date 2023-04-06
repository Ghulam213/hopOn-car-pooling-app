

import 'package:flutter/material.dart';
import 'package:hop_on/core/map/viewmodel/map_view_model.dart';

import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../auth/widgets/login_button.dart';

class SearchPage extends StatefulWidget {
  final Function(String source, String destination) onSuccess;
  final Function() onCloseTap;
  final Function(String) onErrorOccurred;

  SearchPage({
    Key? key,
    required this.onErrorOccurred,
    required this.onCloseTap,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  var focusDestination = FocusNode();

  bool focused = false;

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();

    final MapViewModel mapViewModel = context.watch<MapViewModel>();

    return DraggableScrollableSheet(
        maxChildSize: 0.65,
        minChildSize: 0.5,
        expand: false,
        initialChildSize: 0.65,
        builder: (BuildContext context, ScrollController controller) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 210,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ]),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 24, top: 48, right: 24, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back)),
                            Center(
                              child: Text(
                                'Set Destination',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/pickicon.png',
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_500,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: TextField(
                                    controller: pickupController,
                                    decoration: const InputDecoration(
                                        hintText: 'Pickup location',
                                        fillColor:
                                            AppColors.LM_BACKGROUND_BASIC,
                                        filled: false,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                            left: 10, top: 8, bottom: 8)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/desticon.png',
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_500,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: TextField(
                                    onChanged: (value) {
                                      // searchPlace(value);
                                    },
                                    focusNode: focusDestination,
                                    controller: destinationController,
                                    decoration: const InputDecoration(
                                        hintText: 'Where to?',
                                        fillColor: AppColors.PRIMARY_500,
                                        filled: true,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                            left: 10, top: 8, bottom: 8)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                LoginButton(
                  text: 'Start Ride',
                  onPress: () {
                    mapViewModel.findRides(
                        source: '72.988149,33.642838',
                        destination: '73.087289,33.664512');
                    widget.onSuccess(
                        pickupController.text, destinationController.text);
                  },
                ),
              ],
            ),
          );
        });
  }
}
