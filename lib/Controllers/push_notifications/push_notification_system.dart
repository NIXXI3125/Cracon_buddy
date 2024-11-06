import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/models/user_ride_request_information.dart';
import 'package:drivers_app/Controllers/push_notifications/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String requestId = '';
String originAddress = '';
String destinationAddress = '';
String price = '';
BuildContext? notificationContext;
UserRideRequestInformation userRideRequestDetails =
    UserRideRequestInformation();

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    notificationContext = context;
    // 1. Terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) async {
      print("Remote Message: $remoteMessage");
      requestId = remoteMessage!.data["rideRequestId"].toString();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'call_channel',
          color: Colors.white,
          title: 'Cracon Buddy',
          body: 'New Ride Request',
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.white,
          displayOnBackground: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: "CANCEL",
            label: 'Cancel Ride',
            color: Colors.red,
          ),
          NotificationActionButton(
            key: "ACCEPT",
            label: 'Accept Ride',
            color: Colors.green,
          ),
        ],
      );
      Future.delayed(Duration(seconds: 30), () {
        AwesomeNotifications().cancel(1);
      });
    });

    // 2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      // requestId = remoteMessage.data["rideRequestId"].toString();
      readUserRideRequestInformation(
          remoteMessage.data["rideRequestId"], context);
      // await AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     id: 1,
      //     channelKey: 'call_channel',
      //     color: Colors.white,
      //     title: 'Cracon Buddy',
      //     body: 'New Ride Request',
      //     category: NotificationCategory.Call,
      //     wakeUpScreen: true,
      //     fullScreenIntent: true,
      //     autoDismissible: false,
      //     backgroundColor: Colors.white,
      //     displayOnBackground: true,
      //   ),
      //   actionButtons: [
      //     NotificationActionButton(
      //       key: "CANCEL",
      //       label: 'Cancel Ride',
      //       color: Colors.red,
      //     ),
      //     NotificationActionButton(
      //       key: "ACCEPT",
      //       label: 'Accept Ride',
      //       color: Colors.green,
      //     ),
      //   ],
      // );
      // Future.delayed(Duration(seconds: 30), () {
      //   AwesomeNotifications().cancel(1);
      // });
    });

    // 3. Background
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
    //   readUserRideRequestInformation(
    //       remoteMessage!.data["rideRequestId"], context);
    // });
  }

  readUserRideRequestInformation(
      String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        audioPlayer.open(Audio("music/music_notification.mp3"));
        audioPlayer.play();

        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["originAddress"];

        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["destinationAddress"];

        String userName = (snapData.snapshot.value! as Map)["userName"];
        String userPhone = (snapData.snapshot.value! as Map)["userPhone"];
        String cost = (snapData.snapshot.value! as Map)["user_cost"];
        String? rideRequestId = snapData.snapshot.key;

        UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();

        userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;

        userRideRequestDetails.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;
        userRideRequestDetails.cost = cost;

        userRideRequestDetails.rideRequestId = rideRequestId;

        showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(const Duration(seconds: 30), () {
                Navigator.pop(context);
                FirebaseDatabase.instance
                    .ref()
                    .child("drivers")
                    .child(currentFirebaseUser!.uid)
                    .child("newRideRequest")
                    .remove();
                FirebaseDatabase.instance
                    .ref()
                    .child("drivers")
                    .child(currentFirebaseUser!.uid)
                    .child("newRideStatus")
                    .set("idle")
                    .then((value) {
                  FirebaseDatabase.instance
                      .ref()
                      .child("drivers")
                      .child(currentFirebaseUser!.uid)
                      .child("tripsHistory")
                      .child(userRideRequestDetails.rideRequestId!)
                      .remove();
                });
              });
              return NotificationDialogBox(
                userRideRequestDetails: userRideRequestDetails,
              );
            });
      } else {
        Fluttertoast.showToast(msg: "This Ride Request Id do not exists.");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}

Future<void> backgroundFunction(RemoteMessage message) async {
  print("Remote Message: ${message.data}");
  requestId = message.data["rideRequestId"].toString();
  originAddress = message.data["originAddress"].toString();
  destinationAddress = message.data["destinationAddress"].toString();
  // price = message.data["price"].toString();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'call_channel',
      color: Colors.white,
      title: 'Cracon Buddy',
      body: 'New Ride Request\n$originAddress to $destinationAddress\n',
      category: NotificationCategory.Call,
      payload: {
        "rideRequestId": requestId,
      },
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      backgroundColor: Colors.white,
      displayOnBackground: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: "CANCEL",
        label: 'Cancel Ride',
        color: Colors.red,
      ),
      NotificationActionButton(
        key: "ACCEPT",
        label: 'Accept Ride',
        color: Colors.green,
      ),
    ],

    //   null, [
    //   NotificationChannel(
    //     channelKey: "call_channel",
    //     channelName: "Call Channel",
    //     channelDescription: "Channel Calling",
    //     defaultColor: Colors.white,
    //     ledColor: Colors.white,
    //     importance: NotificationImportance.Max,
    //     channelShowBadge: true,
    //     locked: true,
    //     defaultRingtoneType: DefaultRingtoneType.Ringtone,
    //   )
    // ]
  );
  Future.delayed(Duration(seconds: 30), () {
    AwesomeNotifications().cancel(1);
  });
}

Future<void> actionHandellers(ReceivedAction action) {
  if (action.buttonKeyPressed == "ACCEPT") {
    if (action.payload != null) {
      requestId = action.payload!["rideRequestId"].toString();
      try {
        PushNotificationSystem()
            .readUserRideRequestInformation(requestId, notificationContext!);
      } catch (e) {
        print("Navigation Error $e");
      }
    }
  } else if (action.buttonKeyPressed == "CANCEL") {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideRequest")
        .remove();
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .set("idle")
        .then((value) {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid)
          .child("tripsHistory")
          .child(requestId)
          .remove();
    });
  }
  return Future.value(true);
}
