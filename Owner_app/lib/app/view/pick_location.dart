import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:owner/app/util/theme.dart';

class PickLocationScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const PickLocationScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  static const LatLng _fallbackCenter = LatLng(20.5937, 78.9629); // India

  GoogleMapController? _mapController;
  late LatLng _selected;
  String _address = '';
  bool _loadingAddress = true;
  bool _loadingInitialLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null && widget.initialLat != 0 && widget.initialLng != 0) {
      _selected = LatLng(widget.initialLat!, widget.initialLng!);
      _resolveAddress(_selected);
    } else {
      _selected = _fallbackCenter;
      _useCurrentLocation();
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loadingInitialLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw 'Location permission denied.';
      }
      Position position = await Geolocator.getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      setState(() => _selected = target);
      await _mapController?.animateCamera(CameraUpdate.newLatLng(target));
      _resolveAddress(target);
    } catch (_) {
      _resolveAddress(_selected);
    } finally {
      if (mounted) setState(() => _loadingInitialLocation = false);
    }
  }

  Future<void> _resolveAddress(LatLng target) async {
    setState(() => _loadingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(target.latitude, target.longitude);
      Placemark place = placemarks.first;
      String address = [place.name, place.subLocality, place.locality, place.administrativeArea, place.postalCode, place.country]
          .where((part) => part != null && part.trim().isNotEmpty && part.trim().toLowerCase() != 'null')
          .join(', ');
      if (mounted) setState(() => _address = address);
    } catch (_) {
      if (mounted) setState(() => _address = '${target.latitude.toStringAsFixed(6)}, ${target.longitude.toStringAsFixed(6)}');
    } finally {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.surfaceTint,
      appBar: AppBar(
        backgroundColor: ThemeProvider.appColor,
        iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
        elevation: 0,
        title: const Text('Pick Salon Location', style: ThemeProvider.titleStyle),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _selected, zoom: 16),
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: (position) => _selected = position.target,
            onCameraIdle: () => _resolveAddress(_selected),
          ),
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Icon(Icons.location_on, size: 48, color: ThemeProvider.appColor),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 150,
            child: FloatingActionButton(
              heroTag: 'myLocation',
              backgroundColor: ThemeProvider.whiteColor,
              foregroundColor: ThemeProvider.appColor,
              onPressed: _loadingInitialLocation ? null : _useCurrentLocation,
              child: _loadingInitialLocation ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ThemeProvider.appColor)) : const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: ThemeProvider.whiteColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: ThemeProvider.cardShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 18, color: ThemeProvider.appColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _loadingAddress
                            ? const Text('Fetching address...', style: TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor))
                            : Text(_address.isEmpty ? '${_selected.latitude.toStringAsFixed(6)}, ${_selected.longitude.toStringAsFixed(6)}' : _address,
                                style: const TextStyle(fontSize: 13, color: ThemeProvider.blackColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop({'lat': _selected.latitude, 'lng': _selected.longitude, 'address': _address}),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: ThemeProvider.appColor,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Confirm Location', style: TextStyle(fontFamily: 'semibold', fontSize: 15)),
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
