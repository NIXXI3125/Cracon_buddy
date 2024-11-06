import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  String? token;
  bool? active;
  Map<dynamic, dynamic>? car_details;
  Map<dynamic, dynamic>? driver_details;

  UserModel({
    this.phone,
    this.name,
    this.id,
    this.email,
    this.token,
    this.active,
    this.car_details,
    this.driver_details,
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = (snap.value as dynamic)["name"];
    email = (snap.value as dynamic)["email"];
    token = (snap.value as dynamic)["token"];
    active = (snap.value as dynamic)["active"];
    car_details = (snap.value as dynamic)["car_details"];
    driver_details = (snap.value as dynamic)["driver_details"];
  }
}
