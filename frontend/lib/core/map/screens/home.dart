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
  final LatLng _center = getLatLngFromSharedPrefs();
  // ignore: unused_field
  LatLng _lastMapPosition = const LatLng(33.64333419508494, 72.9914673283913);
  BitmapDescriptor _currentUserIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _driverIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _passengerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setMapIcons();
    }
  }

  setMapIcons() async {
    BitmapDescriptor currentUserIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(22, 22),
      ),
      'assets/images/currentLocation.png',
    );
    BitmapDescriptor driverIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(22, 22),
      ),
      'assets/images/car_ios.png',
    );
    BitmapDescriptor passengerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(22, 22),
      ),
      'assets/images/passenger.png',
    );

    setState(() {
      _currentUserIcon = currentUserIcon;
      _driverIcon = driverIcon;
      _passengerIcon = passengerIcon;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Set<Marker> updateMarker(MapViewModel viewModel, LoginStore loginStore) {
    LatLng pos = const LatLng(33.66672, 73.07099); // fallback
    final Set<Marker> markers = {};
    // lets to the current User first.
    logger('currentLocation: ${viewModel.currentLocation}');
    markers.add(
      Marker(
        markerId: MarkerId(loginStore.userId.toString()),
        position: convertStringToLatLng(viewModel.currentLocation) ?? pos,
        icon: _currentUserIcon,
        infoWindow: const InfoWindow(
          title: "User's Location",
        ),
      ),
    );

    // if user is passenger add drivers marker
    if (!loginStore.isDriver && viewModel.rideId.isNotEmpty && viewModel.rideDriver != null) {
      markers.add(
        Marker(
          markerId: MarkerId(viewModel.rideDriver!.id.toString()),
          position: convertStringToLatLng(viewModel.rideDriver!.currentLocation!) ?? pos,
          icon: _driverIcon,
          infoWindow: const InfoWindow(
            title: "Driver's Location",
          ),
        ),
      );
    } else {
      // if user is driver add passengers marker
      for (var element in viewModel.ridePassengers) {
        markers.add(
          Marker(
            markerId: MarkerId(element!.id!.toString()),
            position: convertStringToLatLng(element.currentLocation!) ?? pos,
            icon: _passengerIcon,
            infoWindow: const InfoWindow(
              title: "Passenger's Location",
            ),
          ),
        );
      }
    }

    return markers;
  }

  Set<Polyline> drawRoute(MapViewModel viewModel) {
    final Set<Polyline> polyline = {};

    polyline.add(
      Polyline(
        polylineId: PolylineId(viewModel.createdRideId.toString()),
        visible: true,
        points: viewModel.polyLineArray,
        width: 8,
        color: AppColors.PRIMARY_500,
      ),
    );
    return polyline;
  }

  Future<List<Set<Object>>> updateMapLocations(MapViewModel viewModel, LoginStore loginStore) async {
    Set<Marker> markers = updateMarker(viewModel, loginStore);
    Set<Polyline> polyline = drawRoute(viewModel);
    return [markers, polyline];
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
              !loginStore.isDriver
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.PRIMARY_500),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: AppColors.PRIMARY_500),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            builder: (context) {
                              return const RegistrationModal();
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Register as a Driver',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 0),
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
                      markers: updateMarker(mapViewModel, loginStore),
                      polylines: drawRoute(mapViewModel),
                      onCameraMove: _onCameraMove,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 14.0,
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

  Widget showModals(SizeConfig config, LoginStore loginStore, MapViewModel viewModel) {
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
                              ? !viewModel.hasDriverAcceptedPassengerRideRequest
                                  ? SearchRidesModal(
                                      onRideRequest: () {},
                                    )
                                  : const SizedBox.shrink()
                              : StartRideModal(
                                  onRideStarted: (String curLoc, String dest) {
                                    Navigator.of(context, rootNavigator: true).pop();
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
