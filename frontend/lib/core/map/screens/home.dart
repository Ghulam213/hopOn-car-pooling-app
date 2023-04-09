// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:hop_on/core/map/modals/search_rides_modal.dart';
import 'package:hop_on/core/map/models/direction.dart';

import 'package:hop_on/core/registration/screens/registration_modal.dart';
import 'package:provider/provider.dart';

// import 'package:latlng/latlng.dart' as latLng;
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/drawer.dart';
import '../viewmodel/map_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? source;
  String? destination;
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  static const LatLng _center = const LatLng(33.642838, 72.98814);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  final List<LatLng> polyLineArray = [];
  // = const [
  //   LatLng(33.684714, 73.048045),
  //   LatLng(33.673281, 73.026413),
  //   LatLng(33.663012, 73.006765),
  //   LatLng(33.652757, 72.987332),
  //   LatLng(33.648144, 72.978459),
  //   LatLng(33.647678, 72.978431),
  //   LatLng(33.645952, 72.979731),
  //   LatLng(33.64621, 72.981138),
  //   LatLng(33.645655, 72.985249),
  //   LatLng(33.64582, 72.985731),
  //   LatLng(33.645435, 72.985988),
  //   LatLng(33.645182, 72.985556),
  //   LatLng(33.645509, 72.985208)
  // ];

  @override
  void initState() {
    super.initState();
  }

  void _onAddMarkerButtonPressed() async {
    LatLng origin = LatLng(33.684714, 73.048045);
    LatLng dest = LatLng(33.645509, 72.985208);

    Dio _dio = Dio();
    final direction = await _dio.post(
        "https://maps.googleapis.com/maps/api/directions/json?",
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${dest.latitude},${dest.longitude}',
          'key': "AIzaSyDP192QwnB-tR8NfjGT3vZCrE-mnkmGFbo"
        });


    final result = direction.data as Map<String, dynamic>;
    debugPrint(result.toString());
    //   if (direction.data.points.isNotEmpty) {
    //   direction.data.points.forEach((PointLatLng point) {
    //     polyLineArray.add(LatLng(point.latitude, point.longitude));
    //   });
    // }
    debugPrint(Directions.fromMap(result).polylinePoints.toString());

    Directions.fromMap(result).polylinePoints.forEach((PointLatLng point) {
      polyLineArray.add(LatLng(point.latitude, point.longitude));
    });


    _markers.add(Marker(
// This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _center,

      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(18, 18)), 'assets/images/car_ios.png'),

      infoWindow: const InfoWindow(
        title: "ride starting",
      ),
    ));

    _polyline.add(Polyline(
      polylineId: PolylineId(_lastMapPosition.toString()),
      visible: true,
      points: polyLineArray,
      color: Colors.red,
    ));

// _controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             _deviceLocation!.latitude,
//             _deviceLocation!.longitude,
//           ),
//           bearing: _deviceLocation!.heading,
//           tilt: 30,
//           zoom: 17,
//         ),
//       ),
//     );
  }

  Future<void> _handlePressButton() async {
    try {} catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = context.watch<MapViewModel>();
    final SizeConfig _config = SizeConfig();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_300,
        toolbarHeight: _config.uiHeightPx * 0.06,
        actions: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.PRIMARY_500),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.PRIMARY_500)),
                  ),
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) {
                        return RegistrationModal(
                          onCloseTap: () {},
                          onErrorOccurred: (String) {},
                        );
                      });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Register as a Driver',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                )),
          )
        ],
      ),
      drawer: const AppDrawer(
        width: 250,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FadeIn(
              duration: const Duration(milliseconds: 1500),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  compassEnabled: false,
                  markers: _markers,
                  polylines: _polyline,
                  onCameraMove: _onCameraMove,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 18.0,
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        duration: const Duration(milliseconds: 1000),
                        child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 100),
                            alignment: Alignment.bottomCenter,
                            height: _config.uiHeightPx * 0.2,
                            width: _config.uiWidthPx * 1,
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0))),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          SearchRidesModal(
                                            onCloseTap: () {},
                                            onErrorOccurred: (String) {},
                                            onRideRequest: () {
                                              // onRideRequested(mapViewModel);
                                            },
                                          ),
                                        ],
                                      )),
                                ])))
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMarkerButtonPressed,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_location, size: 36.0),
      ),
    );
  }
}
