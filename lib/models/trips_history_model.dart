import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? id;
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;
  String? acceptedTime;

  TripsHistoryModel({
    this.id,
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.userName,
    this.userPhone,
    this.acceptedTime,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
    acceptedTime = (dataSnapshot.value as Map)['acceptedTime'];
  }
  TripsHistoryModel.fromJson(Map<dynamic,dynamic> dataSnapshot)
  {
    time = dataSnapshot["time"];
    originAddress = dataSnapshot["originAddress"];
    destinationAddress = dataSnapshot["destinationAddress"];
    status = dataSnapshot["status"];
    fareAmount = dataSnapshot["fareAmount"];
    userName = dataSnapshot["userName"];
    userPhone = dataSnapshot["userPhone"];
    acceptedTime = dataSnapshot['acceptedTime'];
  }
}