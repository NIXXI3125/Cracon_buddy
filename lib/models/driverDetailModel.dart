class Driverdetailmodel {

  late final String DriverLicense;
  late final String DriverPhoto;
  late final String RegistrationCertificate;
  late final String Aadhar;
  late final String PanCard;

  Driverdetailmodel({
    required this.Aadhar,
    required this.DriverLicense,
    required this.DriverPhoto,
    required this.PanCard,
    required this.RegistrationCertificate,
  });

  Driverdetailmodel.fromMap(Map<dynamic,dynamic> json){
    DriverLicense = json['DriverLicense'];
    Aadhar = json['DriverLicense'];
    DriverPhoto = json['DriverLicense'];
    PanCard = json['DriverLicense'];
    RegistrationCertificate = json['DriverLicense'];

  }

}