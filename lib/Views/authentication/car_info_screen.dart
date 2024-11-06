import 'dart:io';

import 'package:drivers_app/Views/authentication/login_screen.dart';
import 'package:drivers_app/colors.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class CarInfoScreen extends StatefulWidget {
  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String aadharCardPath = '';
  String panCardPath = '';
  String RCPath = '';
  String DriverPhotoPath = '';
  String DriverLCPath = '';

  List<String> carTypesList = [
    "Hydra",
    "Fork-Lift",
    "Excavator",
    "Water-Tanker",
    "Truck",
    "Tata-Ace",
    "Eeco",
    "Bike",
    "Three Wheeler",
    "Tractor Trolly",
  ];
  String? selectedCarType;

  saveCarInfo() {
    Map driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    Map DriverInfo = {
      "aadhar": aadharCardPath,
      "pancard": panCardPath,
      "RC": RCPath,
      "DriverPhoto": DriverPhotoPath,
      "DriverLicense": DriverLCPath,
    };

    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");
    driversRef
        .child(currentFirebaseUser!.uid)
        .child("car_details")
        .set(driverCarInfoMap);
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child("drivers");
    driversRef
        .child(currentFirebaseUser!.uid)
        .child("driver_details")
        .set(DriverInfo);

    Fluttertoast.showToast(msg: "Car Details has been saved, Congratulations.");
    fAuth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Write Car Details",
                    style: TextStyle(
                      fontSize: 26,
                      color: textcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primary,
                        width: .6,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        iconSize: 26,
                        dropdownColor: background,
                        borderRadius: BorderRadius.circular(5),
                        underline: null,
                        hint: const Text(
                          "Please choose your Vehicle Type",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: textcolor,
                          ),
                        ),
                        value: selectedCarType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCarType = newValue.toString();
                          });
                        },
                        items: carTypesList.map((car) {
                          return DropdownMenuItem(
                            child: Text(
                              car,
                              style: const TextStyle(color: textcolor),
                            ),
                            value: car,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: carModelTextEditingController,
                    style: const TextStyle(color: textcolor, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Vehicle Model",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(33, 33, 33, 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carNumberTextEditingController,
                    style: const TextStyle(color: textcolor, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Vehicle Number",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(33, 33, 33, 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carColorTextEditingController,
                    style: const TextStyle(color: textcolor, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Vehicle Color",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(33, 33, 33, 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      imagepickerwidget(
                          context: context,
                          title: 'Aadhar Card',
                          path: aadharCardPath,
                          picker: _picker,
                          onImagePicked: (val) {
                            aadharCardPath = val;
                          }),
                      imagepickerwidget(
                          context: context,
                          title: 'Pan Card',
                          path: panCardPath,
                          picker: _picker,
                          onImagePicked: (val) {
                            panCardPath = val;
                          }),
                      imagepickerwidget(
                          context: context,
                          title: 'Driver Photo',
                          path: DriverPhotoPath,
                          picker: _picker,
                          onImagePicked: (val) {
                            DriverPhotoPath = val;
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      imagepickerwidget(
                          context: context,
                          title: 'Driving License',
                          path: DriverLCPath,
                          picker: _picker,
                          onImagePicked: (val) {
                            DriverLCPath = val;
                          }),
                      imagepickerwidget(
                          context: context,
                          title: 'Reg. Certificate',
                          path: RCPath,
                          picker: _picker,
                          onImagePicked: (val) {
                            RCPath = val;
                          }),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (carColorTextEditingController.text.isNotEmpty &&
                          carNumberTextEditingController.text.isNotEmpty &&
                          carModelTextEditingController.text.isNotEmpty &&
                          selectedCarType != null &&
                          aadharCardPath.isNotEmpty &&
                          panCardPath.isNotEmpty &&
                          DriverLCPath.isNotEmpty &&
                          DriverPhotoPath.isNotEmpty &&
                          RCPath.isNotEmpty) {
                        saveCarInfo();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hoverColor,
                    ),
                    child: const Text(
                      "Save Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class imagepickerwidget extends StatefulWidget {
  imagepickerwidget(
      {super.key,
      required this.context,
      required this.title,
      required this.path,
      required this.picker,
      required this.onImagePicked});
  final BuildContext context;
  final String title;
  String path = '';
  final ImagePicker picker;
  final ValueChanged<String> onImagePicked;
  @override
  State<imagepickerwidget> createState() => _imagepickerwidgetState();
}

class _imagepickerwidgetState extends State<imagepickerwidget> {
  final storageRef = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 14, color: textcolor),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              widget.picker
                  .pickImage(source: ImageSource.gallery)
                  .then((value) {
                if (value != null) {
                  String downURL = '';
                  String fileName = value.path.substring(
                      value.path.lastIndexOf("/") + 1,
                      value.path.lastIndexOf("."));

                  Reference upload =
                      storageRef.ref('${currentFirebaseUser!.uid}/$fileName');
                  UploadTask uploadTsk = upload.putFile(File(value.path));
                  uploadTsk.whenComplete(() async {
                    downURL = await upload.getDownloadURL();
                    print(downURL);
                    setState(() {
                      widget.path = value.path;
                      widget.onImagePicked(downURL ?? '');
                    });
                  });
                }
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primary,
                  width: 1.25,
                ),
              ),
              child: (widget.path != '')
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(widget.path),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.upload_rounded,
                        color: primary,
                        size: 40,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
