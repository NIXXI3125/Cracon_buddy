import 'dart:async';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:drivers_app/Controllers/assistants/assistant_methods.dart';
import 'package:drivers_app/Controllers/providers/homeScreenProvider.dart';
import 'package:drivers_app/Views/authentication/login_screen.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/Views/tabPages/home_tab.dart';
import 'package:drivers_app/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
    with WidgetsBindingObserver {
  FirebaseAuth _Auth = FirebaseAuth.instance;
  var overlayPermission;
  var postNotificationPermission;
  startTimer() {
    Timer(
      const Duration(seconds: 3),
      () async {
        if (_Auth.currentUser != null) {
          currentFirebaseUser = _Auth.currentUser;
          currentFirebaseUser!.reload();
          print(currentFirebaseUser);
          if (currentFirebaseUser!.emailVerified) {
            AssistantMethods.readDriverEarnings(context);
            AssistantMethods.readTripsHistoryInformation(context);
            AssistantMethods.readDriverRatings(context);
            AssistantMethods.readCostforEvery();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (c) => ChangeNotifierProvider(
                          create: (context) => HomeScreenProvider(),
                          child: const HomeTabPage(),
                        )),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => LoginScreen()),
                (route) => false);
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => LoginScreen()),
              (route) => false);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    checkOverlayPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  void checkOverlayPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int AndroidVersion = int.parse(androidInfo.version.release);
    if (AndroidVersion <= 13) {
      overlayPermission = await DashBubble.instance.hasOverlayPermission();
      postNotificationPermission =
          await DashBubble.instance.hasPostNotificationsPermission();
      if (!overlayPermission) {
        DashBubble.instance.requestOverlayPermission();
      }
      if (!postNotificationPermission) {
        DashBubble.instance.requestPostNotificationsPermission();
      }
    }
  }

  // @override
  // void didChangeAppLifeCycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.detached) {
  //     print("App state is: $state");
  //     Geofire.removeLocation(currentFirebaseUser!.uid);
  //     DatabaseReference? ref = FirebaseDatabase.instance
  //         .ref()
  //         .child("drivers")
  //         .child(currentFirebaseUser!.uid)
  //         .child("newRideStatus");
  //     ref.onDisconnect();
  //     ref.remove();
  //     ref = null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("android/images/ultra.png", height: 300),
              Image.asset(
                'android/images/logo.png',
                height: 35,
              ),
              const Text(
                "Buddy",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
