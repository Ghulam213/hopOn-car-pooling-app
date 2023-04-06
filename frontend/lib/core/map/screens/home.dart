// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:hop_on/core/map/modals/search_rides_modal.dart';
import 'package:hop_on/core/map/screens/search_page.dart';
// import 'package:latlng/latlng.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import '../../../Utils/helpers.dart';
import 'package:latlong2/latlong.dart' as latLng;
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kRestaurantsList;
  List<Map> carouselData = [];
  LatLng initLatLng = LatLng(72.9914673283913, 33.64333419508494);
  // getLatLngFromSharedPrefs();

  Line? _selectedLine;
  String? source;
  String? destination;
  int _lineCount = 0;
  final Random _rnd = new Random();

// Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;
  List<Marker> _markers = [];
  List<_MarkerState> _markerStates = [];

  final List<LatLng> polyLineArray = const [
    LatLng(33.684714, 73.048045),
    LatLng(33.673281, 73.026413),
    LatLng(33.663012, 73.006765),
    LatLng(33.652757, 72.987332),
    LatLng(33.648144, 72.978459),
    LatLng(33.647678, 72.978431),
    LatLng(33.645952, 72.979731),
    LatLng(33.64621, 72.981138),
    LatLng(33.645655, 72.985249),
    LatLng(33.64582, 72.985731),
    LatLng(33.645435, 72.985988),
    LatLng(33.645182, 72.985556),
    LatLng(33.645509, 72.985208)
  ];

  @override
  void initState() {
    super.initState();
    _initialCameraPosition =
        CameraPosition(target: LatLng(73.048010, 33.684757), zoom: 15);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;

    debugPrint(initLatLng.toString());

    controller.onLineTapped.add(_onLineTapped);
    controller.addListener(() {
      if (controller.isCameraMoving) {
        _updateMarkerPosition();
      }
    });
  }

  _onLineTapped(Line line) async {
    await _updateSelectedLine(
      const LineOptions(lineColor: "#ff0000"),
    );
    setState(() {
      _selectedLine = line;
    });
    await _updateSelectedLine(
      const LineOptions(lineColor: "#ffe100"),
    );
  }

  _updateSelectedLine(LineOptions changes) async {
    if (_selectedLine != null) controller.updateLine(_selectedLine!, changes);
  }

  _onStyleLoadedCallback(MapViewModel model) async {
    if (model.availableRides.isNotEmpty) {
      await controller.addLine(
        LineOptions(
            geometry:
                convertListToListLatLng(model.availableRides[0].polygonPoints),
            lineColor: "#000000",
            lineWidth: 4.0,
            lineOpacity: 0.9,
            draggable: false),
      );


      setState(() {
        _markers.add(Marker(
            _rnd.nextInt(100000).toString(),
            LatLng(double.parse('33.64333419508494'),
                double.parse('72.9914673283913')),
            Point(720.966796875, 575.681884765625),
            _addMarkerStates));
      });
    }
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

// void _add() {
//     controller.addLine(
//       const LineOptions(
//           geometry: [
//             LatLng(73.047884, 33.684419),
//             LatLng(73.044814, 33.685522)
//           ],
//           lineColor: "#89CFF0",
//           lineWidth: 14.0,
//           lineOpacity: 0.9,
//           draggable: false),
//     );
//     setState(() {
//       _lineCount += 1;
//     });
//   }

  void _addMarkerStates(_MarkerState markerState) {
    _markerStates.add(markerState);
  }

  void _onMapLongClickCallback(Point<double> point, LatLng coordinates) {
    debugPrint('HEERRRRRR');
    debugPrint(point.toString());
    debugPrint(coordinates.toString());
    _addMarker(point, coordinates);
  }

  void _onCameraIdleCallback() {
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    controller.toScreenLocationBatch(coordinates).then((points) {
      _markerStates.asMap().forEach((i, value) {
        _markerStates[i].updatePosition(points[i]);
      });
    });
  }

  void _addMarker(Point<double> point, LatLng coordinates) {
    setState(() {
      _markers.add(Marker(_rnd.nextInt(100000).toString(), coordinates, point,
          _addMarkerStates));
    });
  }

  _move() async {
    final currentStart = _selectedLine!.options.geometry![0];
    final currentEnd = _selectedLine!.options.geometry![1];
    final end =
        LatLng(currentEnd.latitude + 0.001, currentEnd.longitude + 0.001);
    final start =
        LatLng(currentStart.latitude - 0.001, currentStart.longitude - 0.001);
    await controller!
        .updateLine(_selectedLine!, LineOptions(geometry: [start, end]));
  }

  void _remove() {
    controller!.removeLine(_selectedLine!);
    setState(() {
      _selectedLine = null;
      _lineCount -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = context.watch<MapViewModel>();
    final SizeConfig _config = SizeConfig();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_300,
        toolbarHeight: _config.uiHeightPx * 0.06,
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
                child: MapboxMap(
                  accessToken:
                      'pk.eyJ1IjoiaG9wb25hcHAiLCJhIjoiY2xkbHl0Ynp5MDRjMzNua2J6ZTVxYTdoayJ9.aszB3q-5-dPp3fYIn05O6g',
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: _onMapCreated,
                  onMapLongClick: _onMapLongClickCallback,
                  // onCameraIdle: _onCameraIdleCallback,
                  myLocationEnabled: true,
                  myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                  minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
                  onStyleLoadedCallback: () =>
                      _onStyleLoadedCallback(mapViewModel),
                ),
              ),
            ),
            // Marker(
            //     _rnd.nextInt(100000).toString(),
            //     LatLng(double.parse('33.64333419508494'),
            //         double.parse('72.9914673283913')),
            //     Point(720.966796875, 575.681884765625),
            //     _addMarkerStates),
            IgnorePointer(
                ignoring: true,
                child: Stack(
                  children: _markers,
                )),
            Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        duration: const Duration(milliseconds: 2000),
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
                                  // Container(
                                  //     width: 80,
                                  //     height: 2.875,
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: const BorderRadius.all(
                                  //           Radius.circular(80)),
                                  //       color:
                                  //           AppColors.PRIMARY_500,
                                  //     )),
                     
                              SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      SearchRidesModal(
                                        onCloseTap: () {},
                                        onErrorOccurred: (String) {},
                                        onSuccess: () {},
                                      ),
                                    ],
                                      )),
                          
                            ])))
                  ],
                ))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     controller.animateCamera(
      //         CameraUpdate.newCameraPosition(_initialCameraPosition));
      //     await showModalBottomSheet(
      //         context: context,
      //         isScrollControlled: true,
      //         useRootNavigator: true,
      //         builder: (context) {
      //           return SearchPage(
      //             onCloseTap: () {},
      //             onErrorOccurred: (String) {},
      //             onSuccess: (String source, String destination) {},
      //           );
      //         });
      //   },
      //   child: const Center(
      //     child: Icon(
      //       Icons.search,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    );
  }
}

class Marker extends StatefulWidget {
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(_MarkerState) _addMarkerState;

  Marker(
      String key, this._coordinate, this._initialPosition, this._addMarkerState)
      : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = _MarkerState(_initialPosition);
    _addMarkerState(state);
    return state;
  }
}

class _MarkerState extends State with TickerProviderStateMixin {
  final _iconSize = 20.0;

  Point _position;

  late AnimationController _controller;
  late Animation<double> _animation;

  _MarkerState(this._position);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
        left: _position.x / ratio - _iconSize / 2,
        top: _position.y / ratio - _iconSize / 2,
        child: Image.asset('assets/images/car_ios.png', height: _iconSize));
  }

  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as Marker)._coordinate;
  }
}
