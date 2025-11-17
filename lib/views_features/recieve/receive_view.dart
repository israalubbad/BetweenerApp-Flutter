import 'dart:async';
import 'package:betweener_app/core/helpers/context_extenssion.dart';
import 'package:betweener_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../models/user_location.dart';

class ReceiveView extends StatefulWidget {
  static String id = '/receiveView';

  const ReceiveView({super.key});

  @override
  State<ReceiveView> createState() => _ReceiveViewState();
}

class _ReceiveViewState extends State<ReceiveView> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  @override
  void initState() {
    super.initState();
    _init();
  }

  // Request location permission, load saved user location,
  Future<void> _init() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      context.showSnackBar(message:"Location permission denied" , error: true );
      return;
    }

    // get user in SharedPreferences
    await Provider.of<UserProvider>(context, listen: false).loadUser();

    final userProvider =
        Provider.of<UserProvider>(context, listen: false).userResponse;

    if (userProvider?.data != null &&
        userProvider!.data!.user.lat != null &&
        userProvider.data!.user.long != null) {

      double lat = double.parse(userProvider.data!.user.lat.toString());
      double long = double.parse(userProvider.data!.user.long.toString());

      _setLocation(LatLng(lat, long));
      return;
    }

    // If no saved location get GPS location
    await _getGPSLocation();
  }

  // Get GPS location, update it on the API , and set it on the map.
  Future<void> _getGPSLocation() async {
    UserLocation loc = UserLocation();
    await loc.getLocation();

    await Provider.of<UserProvider>(context, listen: false)
        .updateLocation(loc.latitude, loc.longitude);

    _setLocation(LatLng(loc.latitude, loc.longitude));
  }

  // Update current location, marker, and move camera.
  void _setLocation(LatLng pos) {
    setState(() {
      _currentLocation = pos;
      _markers = {
        Marker(
          markerId: const MarkerId("marker"),
          position: pos,
        ),
      };
    });

    _moveCamera(pos);
  }

  // Handle map tap: update location on API and refresh marker.
  Future<void> _handleTap(LatLng pos) async {
    await Provider.of<UserProvider>(context, listen: false)
        .updateLocation(pos.latitude, pos.longitude);

    _setLocation(pos);
  }

  // Animate the map camera to a given position.
  Future<void> _moveCamera(LatLng target) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(target, 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Location"),
        centerTitle: true,
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 16,
        ),
        onMapCreated: (controller) => _controller.complete(controller),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        // if user click in map
        onTap: _handleTap,
        markers: _markers,
      ),
    );
  }
}
