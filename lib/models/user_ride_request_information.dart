import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation {
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;
  String? cost;

  UserRideRequestInformation(
      {this.originLatLng,
      this.destinationLatLng,
      this.originAddress,
      this.destinationAddress,
      this.rideRequestId,
      this.userName,
      this.userPhone,
      this.cost});

  factory UserRideRequestInformation.fromMap(Map<String, dynamic> map) {
    return UserRideRequestInformation(
        originLatLng: LatLng(
            map["originLatLng"]["latitude"], map["originLatLng"]["longitude"]),
        destinationLatLng: LatLng(map["destinationLatLng"]["latitude"],
            map["destinationLatLng"]["longitude"]),
        originAddress: map["originAddress"],
        destinationAddress: map["destinationAddress"],
        rideRequestId: map["rideRequestId"],
        userName: map["userName"],
        userPhone: map["userPhone"],
        cost: map["cost"]);
  }

  Map<String, dynamic> toMap(
      UserRideRequestInformation userRideRequestInformation) {
    Map<String, dynamic> userRideRequestInformationMap = Map();
    userRideRequestInformationMap["originLatLng"] =
        userRideRequestInformation.originLatLng;
    userRideRequestInformationMap["destinationLatLng"] =
        userRideRequestInformation.destinationLatLng;
    userRideRequestInformationMap["originAddress"] =
        userRideRequestInformation.originAddress;
    userRideRequestInformationMap["destinationAddress"] =
        userRideRequestInformation.destinationAddress;
    userRideRequestInformationMap["rideRequestId"] =
        userRideRequestInformation.rideRequestId;
    userRideRequestInformationMap["userName"] =
        userRideRequestInformation.userName;
    userRideRequestInformationMap["userPhone"] =
        userRideRequestInformation.userPhone;
    userRideRequestInformationMap["cost"] = userRideRequestInformation.cost;

    return userRideRequestInformationMap;
  }
}
