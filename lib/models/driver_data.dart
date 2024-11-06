import 'package:drivers_app/models/driverDetailModel.dart';

class DriverData {
  //attributes
  String? id;
  String? name;
  String? phone;
  String? email;
  bool? active;
  String? car_color;
  String? car_model;
  String? car_number;
  String? driverVehicleType;
  Driverdetailmodel? driver_details;

  DriverData({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.active,
    this.car_color,
    this.car_model,
    this.car_number,
    this.driverVehicleType,
    this.driver_details,
  });

  factory DriverData.fromJson(Map<dynamic, dynamic> json) {
    return DriverData(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      active: json['active'],
      car_color: json["car_details"]['car_color'],
      car_model: json["car_details"]['car_model'],
      car_number: json["car_details"]['car_number'],
      driverVehicleType: json["car_details"]['type'],
      driver_details: Driverdetailmodel.fromMap(json["driver_details"])
    );
  }
}
