import 'package:drivers_app/Controllers/assistants/request_assistant.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/Controllers/global/map_key.dart';
import 'package:drivers_app/Controllers/infoHandler/app_info.dart';
import 'package:drivers_app/models/costs.dart';
import 'package:drivers_app/models/direction_details_info.dart';
import 'package:drivers_app/models/directions.dart';
import 'package:drivers_app/models/trips_history_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  }

  static Stream StopwatchFromStarttillEnd() async* {
    DatabaseEvent query1 = await FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child('newRideRequest')
        .once();
    print("Q2" + query1.snapshot.value.toString());
    // activeTrip = TripsHistoryModel.fromJson(data.keys);
    await FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(query1.snapshot.value.toString())
        .onValue
        .listen((accept) {
      Map data = accept.snapshot.value as Map;

      print(data);
      activeTrip = TripsHistoryModel.fromJson(data as Map<dynamic, dynamic>);
    });
    final DateTime startTime = DateTime.parse(activeTrip.acceptedTime!);
    print(startTime);
    yield* Stream.periodic(Duration(seconds: 1), (tick) {
      final now = DateTime.now();
      final remaining = now.difference(startTime);
      final hour = (remaining.inSeconds ~/ 3600).toString().padLeft(2, '0');
      final minute =
          ((remaining.inSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
      final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
      return ("${hour}:${minute}:${seconds}");
    });
    // yield activeTrip.acceptedTime ?? 'Doesn\'t exist' ;
  }

  static Future<double> calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo,
      {required String userRideRequestId}) async {
    DatabaseEvent data = await FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .once();
    double calculate = double.parse((data.snapshot.value as Map)['user_cost']
        .toString()
        .replaceAll('₹', ''));
    print(calculate);
    return calculate;
    // double timeTraveledFareAmountPerMinute =
    //     (directionDetailsInfo.duration_value! / 60) * 0.1;
    // double distanceTraveledFareAmountPerKilometer =
    //     (directionDetailsInfo.distance_value! / 1000) * 0.1;

    // //USD
    // double totalFareAmount = timeTraveledFareAmountPerMinute +
    //     distanceTraveledFareAmountPerKilometer;
    // driverVehicleType = onlineDriverData.driverVehicleType;
    // print(" Vehicle Type " + driverVehicleType!);
    // if (driverVehicleType == "Eeco") {
    //   double resultFareAmount = totalFareAmount * Costing.Eeco!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Truck") {
    //   print((totalFareAmount * Costing.Truck!.truncate()).truncateToDouble());
    //   return (totalFareAmount * Costing.Truck!.truncate()).truncateToDouble();
    // } else if (driverVehicleType == "Tata-AcE") {
    //   double resultFareAmount = (totalFareAmount) * Costing.TataAce!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Hydra") {
    //   double resultFareAmount = (totalFareAmount) * Costing.Hydra!.truncate();
    //   return resultFareAmount;
    // } else if (driverVehicleType == "Excavator") {
    //   double resultFareAmount =
    //       (totalFareAmount) * Costing.Excavator!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Bike") {
    //   double resultFareAmount = (totalFareAmount) * Costing.bike!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Water-Tanker") {
    //   double resultFareAmount =
    //       (totalFareAmount) * Costing.WaterTanker!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Three Wheeler") {
    //   double resultFareAmount =
    //       (totalFareAmount) * Costing.ThreeWheeler!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Tractor Trolly") {
    //   double resultFareAmount =
    //       (totalFareAmount) * Costing.TractorTrolley!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else if (driverVehicleType == "Fork-Lift") {
    //   double resultFareAmount =
    //       (totalFareAmount) * Costing.ForkLift!.truncate();
    //   return resultFareAmount.truncateToDouble();
    // } else {
    //   print(((totalFareAmount) * Costing.HourlyRate!.truncate())
    //       .truncateToDouble());
    //   return ((totalFareAmount) * Costing.HourlyRate!.truncate())
    //       .truncateToDouble();
    // }
  }

  //retrieve the trips KEYS for online user
  //trip key = ride request key
  static void readCostforEvery() {
    FirebaseDatabase.instance.ref().child("Globals").once().then((snap) {
      Costing =
          CostModel.fromJson(snap.snapshot.value as Map<dynamic, dynamic>);
      print("Cost Model= ${Costing.HourlyRate}");
    });
  }

  static void readTripsKeysForOnlineDriver(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        print("Total trips: ${overAllTripsCounter}");
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for (String eachKey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap) {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if ((snap.snapshot.value as Map)["status"] == "ended") {
          //update-add each history to OverAllTrips History Data List
          print(eachTripHistory);
          Provider.of<AppInfo>(context, listen: false)
              .updateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        double driverEarnings = double.parse(snap.snapshot.value.toString());
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverTotalEarnings(driverEarnings.truncate().toString());
      }
    });

    readTripsKeysForOnlineDriver(context);
  }

  static void readDriverRatings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap) {
      print('ratings: ${snap.snapshot.value}');
      if (snap.snapshot.value != null) {
        print('ratings: ${snap.snapshot.value}');
        double driverRatings = double.parse(snap.snapshot.value.toString());
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverAverageRatings(driverRatings);
      }
    });
  }
}
