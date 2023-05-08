import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:hop_on/core/map/modals/driver_start_ride_modal.dart';
import 'package:hop_on/core/map/modals/search_rides_modal.dart';
import 'package:hop_on/core/registration/screens/registration_modal.dart';
import 'package:provider/provider.dart';

import '../../../Utils/helpers.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../auth/provider/login_store.dart';
import '../../widgets/drawer.dart';
import '../viewmodel/map_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
 
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  final LatLng _center = getLatLngFromSharedPrefs();
  late LatLng _lastMapPosition;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _drawRoute(
      String? source, String? destination, MapViewModel viewModel) async {

    // Note: update will real cords when not testing
    LatLng src = const LatLng(33.64333419508494, 72.9914673283913);
    LatLng dest = const LatLng(33.65879628444844, 73.08346009601216);

    viewModel.getDirections(
        source: '${src.latitude},${src.longitude}',
        destination: '${dest.latitude},${dest.longitude}');

    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: src,

      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(18, 18)),
          'assets/images/car_ios.png'),
      infoWindow: const InfoWindow(
        title: "ride starting",
      ),
    ));

    _polyline.add(Polyline(
      polylineId: PolylineId(source.toString()),
      visible: true,
      points: viewModel.polyLineArray,
      color: Colors.red,
    ));

    viewModel.createRide(
      source: '33.64333419508494, 72.9914673283913',
      destination: '33.65879628444844, 73.08346009601216',
      currentLocation: '33.684714,73.048045',
      totalDistance: 50,
      city: 'Islamabad',
      polygonPoints: viewModel.polyLineArray,
    );

    viewModel.updateDriverLoc(
        rideId: '148a0a27-ed88-422b-be7f-19a35872f287',
        currentLocation: '33.684714,73.048045');
  }

  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = context.watch<MapViewModel>();
    final SizeConfig config = SizeConfig();

    return Consumer<LoginStore>(builder: (context, loginStore, _) {
      return Observer(
        builder: (_) => (Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.PRIMARY_300,
            toolbarHeight: config.uiHeightPx * 0.06,
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
                          side: const BorderSide(color: AppColors.PRIMARY_500)),
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
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Register as a Driver',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
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
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: _markers,
                      polylines: _polyline,
                      onCameraMove: _onCameraMove,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16.0,
                      ),
                    ),
                  ),
                ),
                showModals(config, loginStore, mapViewModel)
              ],
            ),
          ),
        )),
      );
    });
  }

  Widget showModals(
      SizeConfig config, LoginStore loginStore, MapViewModel viewModel) {
    return Positioned(
      bottom: 0,
      child: Column(
        children: [
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.bottomCenter,
              height: config.uiHeightPx * 0.2,
              width: config.uiWidthPx * 1,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        InkWell(
                          child: !loginStore.isDriver
                              ? SearchRidesModal(                               
                                  onRideRequest: () {
                                    // viewModel.requestRide(source: ,rideId: ,destination: ,distance: );
                                  },
                                )
                              : StartRideModal(
                                  onRideStarted: (String curLoc, String dest) {
                                    _drawRoute(curLoc, dest, viewModel);

                                    Navigator.of(context).pop();
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
