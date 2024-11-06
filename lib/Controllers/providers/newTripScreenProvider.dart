import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum NewTripScreenState {
  initial,
  loading,
  loaded,
  error,
}

class Newtripscreenprovider extends ChangeNotifier {
  NewTripScreenState state = NewTripScreenState.initial;

  createDriverIconMarker(BuildContext context){
    ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
     return BitmapDescriptor.fromAssetImage(
              imageConfiguration, "android/images/car.png");

  }

  RealtimeDriverlocationupdate(){

  }
}