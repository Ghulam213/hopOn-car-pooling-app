// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hop_on/core/map/screens/search_page.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../../../Utils/constants.dart';
import '../../../Utils/helpers.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../registration/viewmodel/registration_viewmodel.dart';
import '../../widgets/drawer.dart';
import '../widgets/coursel_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kRestaurantsList;
  List<Map> carouselData = [];
  LatLng latLng = getLatLngFromSharedPrefs();

  String? source;
  String? destination;

// Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: 15);

    for (int index = 0; index < restaurants.length; index++) {
      num distance = 100; //getDistanceFromSharedPrefs(index) / 1000;
      num duration = 30; //getDurationFromSharedPrefs(index) / 60;
      carouselData
          .add({'index': index, 'distance': distance, 'duration': duration});
    }
    carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
        restaurants.length,
        (index) => carouselCard(carouselData[index]['index'],
            carouselData[index]['distance'], carouselData[index]['duration']));

    // initialize map symbols in the same order as carousel widgets
    _kRestaurantsList = List<CameraPosition>.generate(
        restaurants.length,
        (index) => CameraPosition(
            target: getLatLngFromRestaurantData(carouselData[index]['index']),
            zoom: 15));
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    // controller.animateCamera(
    //     CameraUpdate.newCameraPosition(_kRestaurantsList[index]));

    // Add a polyLine between source and destination
    // Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);

    controller
        .moveCamera(CameraUpdate.newCameraPosition(_kRestaurantsList[index]));

    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    // await showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     useRootNavigator: true,
    //     builder: (context) {
    //       return SearchPage(
    //         // data: data,
    //         onSuccess: (src, dest) {
    //           setState(() {
    //             source = src;
    //             destination = dest;
    //           });

    //           Navigator.of(_scaffoldKey.currentContext!).pop();
    //         },
    //       );
    //     });
  }

  onRideRequested(MapboxMapController controller) async {
    final RegistrationViewModel registrationViewModel =
        context.watch<RegistrationViewModel>();


  }

  @override
  Widget build(BuildContext context) {

    final SizeConfig _config = SizeConfig();
         
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: _config.uiHeightPx * 0.06,
      ),
      drawer: AppDrawer(
        width: 250,
      ),
      body: SafeArea(
        child: Stack(
          children: [
        

            SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: MapboxMap(
                accessToken:
                    'pk.eyJ1IjoiaG9wb25hcHAiLCJhIjoiY2xkbHl0Ynp5MDRjMzNua2J6ZTVxYTdoayJ9.aszB3q-5-dPp3fYIn05O6g',
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
              ),
            ),
            // SizedBox(
            //   child: CarouselSlider(
            //       items: carouselItems,
            //       options: CarouselOptions(
            //           height: 110,

            //           viewportFraction: 0.6,
            //           initialPage: 0,
            //           enableInfiniteScroll: false,
            //           scrollDirection: Axis.horizontal,
            //           onPageChanged:
            //               (int index, CarouselPageChangedReason reason) {
            //             setState(() {
            //               pageIndex = index;
            //             });
            //             _addSourceAndLineLayer(index, true);
            //           })),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              builder: (context) {
                return SearchPage(
                  onCloseTap: () {},
                  onErrorOccurred: (String) {},
                  onSuccess: (src, dest) async {
                    Navigator.of(context).pop();
                    setState(() {
                      source = src;
                      destination = dest;
                    });
                  },
                );
              });
        },
        child: const Center(
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
