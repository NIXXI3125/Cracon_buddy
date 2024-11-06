import 'package:drivers_app/colors.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/widgets/document_widget.dart';
import 'package:flutter/material.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: textcolor,
        ),
        backgroundColor: primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Column(
        children: [
          Row(
            children: [
              documentlistwidget(
                  imgSource: onlineDriverData.driver_details!.Aadhar,
                  title: 'Aadhar Card'),
              documentlistwidget(
                  imgSource: onlineDriverData.driver_details!.PanCard,
                  title: 'Pan Card'),
            ],
          ),
          Row(
            children: [
              documentlistwidget(
                  imgSource:
                      onlineDriverData.driver_details!.RegistrationCertificate,
                  title: 'Registration Certificate'),
              documentlistwidget(
                  imgSource: onlineDriverData.driver_details!.DriverLicense,
                  title: 'Driver License'),
            ],
          ),
        ],
      ),
    );
  }
}
