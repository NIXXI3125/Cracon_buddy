import 'dart:async';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:drivers_app/Controllers/providers/WalletProvider.dart';
import 'package:drivers_app/Controllers/assistants/assistant_methods.dart';
import 'package:drivers_app/Controllers/providers/homeScreenProvider.dart';
import 'package:drivers_app/Views/authentication/login_screen.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/Controllers/infoHandler/app_info.dart';
import 'package:drivers_app/Views/mainScreens/document_screen.dart';
import 'package:drivers_app/Views/mainScreens/wallet_screen.dart';
import 'package:drivers_app/models/trips_history_model.dart';
import 'package:drivers_app/Controllers/push_notifications/push_notification_system.dart';
import 'package:drivers_app/Views/tabPages/earning_tab.dart';
import 'package:drivers_app/Views/tabPages/profile_tab.dart';
import 'package:drivers_app/widgets/ride_history_list_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../models/driver_data.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4.4746,
  );

  CameraPosition _driverCurrentPosition = _kGooglePlex;
  TextEditingController phoneController = TextEditingController();
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  DriverData driverData = DriverData();

  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    _driverCurrentPosition = CameraPosition(target: latLngPosition, zoom: 14);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    AssistantMethods.readDriverRatings(context);
  }

  StreamSubscription<DatabaseEvent> readCurrentDriverInformation() {
    currentFirebaseUser = fAuth.currentUser;
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();

    return FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .onValue
        .listen(
      (DatabaseEvent snap) {
        if (snap.snapshot.value != null) {
          setState(() {
            onlineDriverData = DriverData.fromJson(snap.snapshot.value as Map);
            driverData = DriverData.fromJson(snap.snapshot.value as Map);
            print('User: ${driverData.driverVehicleType}');
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
    locateDriverPosition();

    AssistantMethods.readDriverEarnings(context);
    AssistantMethods.readTripsHistoryInformation(context);
    AssistantMethods.readDriverRatings(context);
    AssistantMethods.readCostforEvery();
    Provider.of<HomeScreenProvider>(context, listen: false).getAllTrips();
    Provider.of<HomeScreenProvider>(context, listen: false).getWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
    List<TripsHistoryModel> historyList =
        Provider.of<AppInfo>(context, listen: false)
            .allTripsHistoryInformationList;
    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    accountName: Text(
                      onlineDriverData.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      onlineDriverData.car_number ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.orange,
                        size: 50,
                      ),
                    ),
                  ),
                  (currentFirebaseUser!.phoneNumber == '')
                      ? ListTile(
                          tileColor: Colors.red,
                          title: Column(
                            children: [
                              Text(
                                'Please Update Your Phone Number',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter Phone Number',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      '+91',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                        Icons.arrow_circle_right_rounded,
                                        size: 26,
                                        color: Colors.white),
                                    onPressed: () {
                                      print(
                                          'Phone Number: ${phoneController.text}');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListTile(
                          tileColor: Colors.red,
                          title: Text(
                            currentFirebaseUser!.phoneNumber ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const ProfileTabPage()));
                    },
                    title: const Text(
                      'Your Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.orange,
                    ),
                    title: const Text(
                      'Your Documents',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const DocumentScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const EarningsTabPage()));
                    },
                    title: const Text(
                      'Ride History',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.wallet,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => WalletProvider(),
                                child: const WalletScreen(),
                              )));
                    },
                    splashColor: Colors.transparent,
                    title: const Text(
                      'Wallet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                tileColor: Colors.red,
                onTap: () {
                  fAuth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset(
          'android/images/logo.png',
          height: 35,
        ),
        leadingWidth: 80,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (isDriverActive)
            ? HorizontalSlidableButton(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 3,
                buttonWidth: 70.0,
                initialPosition: SlidableButtonPosition.end,
                color: Colors.red.withOpacity(0.7),
                buttonColor: Colors.orange,
                dismissible: false,
                autoSlide: true,
                isRestart: true,
                label: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Go Offline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: (position) {
                  driverIsOfflineNow();

                  setState(() {
                    statusText = "Offline";
                    isDriverActive = false;
                    buttonColor = Colors.greenAccent;
                  });

                  //display Toast
                  Fluttertoast.showToast(msg: "you are Offline Now");
                },
              )
            : HorizontalSlidableButton(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 3,
                buttonWidth: 70.0,
                color: Colors.green.withOpacity(0.7),
                buttonColor: Colors.orange,
                dismissible: false,
                autoSlide: true,
                isRestart: true,
                label: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Go Online',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: (position) {
                  if (!isDriverActive) {
                    driverIsOnlineNow();
                    updateDriversLocationAtRealTime();

                    setState(() {
                      statusText = "Now Online";
                      isDriverActive = true;
                      buttonColor = Colors.transparent;
                    });

                    //display Toast
                    Fluttertoast.showToast(msg: "you are Online Now");
                  } else {
                    driverIsOfflineNow();

                    setState(() {
                      statusText = "Offline";
                      isDriverActive = false;
                      buttonColor = Colors.greenAccent;
                    });

                    //display Toast
                    Fluttertoast.showToast(msg: "you are Offline Now");
                  }
                },
              ),
      ),
      body: Consumer<HomeScreenProvider>(builder: (context, screenProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => WalletProvider(),
                        child: const WalletScreen(),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Wallet',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.call_made,
                              size: 26,
                              color: Colors.green,
                              fill: 1,
                              weight: 500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.wallet,
                            size: 50,
                            color: Colors.white,
                            weight: 200,
                          ),
                          Spacer(),
                          Text(
                            '${screenProvider.WalletBalance}' ?? '0',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const EarningsTabPage()));
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ride History',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.call_made,
                                  size: 26,
                                  color: Colors.green,
                                  fill: 1,
                                  weight: 500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: constraints.maxHeight * 0.7,
                            alignment: Alignment.center,
                            child: (screenProvider.state ==
                                    HomeScreenStateStatus.loading)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : (screenProvider.tripsHistory.isNotEmpty)
                                    ? ListView.builder(
                                        itemCount:
                                            screenProvider.tripsHistory.length,
                                        itemBuilder: (context, index) {
                                          final isfirst = index == 0;
                                          final isLast =
                                              index == (historyList.length);
                                          return RideHistoryListWidget(
                                            amount: double.parse(
                                                historyList[index].fareAmount!),
                                            originLocation: historyList[index]
                                                .originAddress!,
                                            destinationLocation:
                                                historyList[index]
                                                    .destinationAddress!,
                                            trID: '00000000000000',
                                            isFirst: isfirst,
                                            isLast: isLast,
                                            tripDate: DateTime.parse(
                                                historyList[index].time!),
                                            tripTime: DateFormat.jm().format(
                                              DateTime.parse(
                                                  historyList[index].time!),
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text('You didn\'t did a Ride.'),
                                      ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideRequest")
        .remove();
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) {});
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), () {
      //SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return (onlineDriverData.active != null && onlineDriverData.active == true)
  //       ? Scaffold(
  //         backgroundColor: Colors.black,
  //           floatingActionButton: FloatingActionButton(
  //             onPressed: () async {
  //               newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(_driverCurrentPosition));
  //             },
  //             child: const Icon(
  //               Icons.gps_fixed_rounded,
  //             ),
  //           ),
  //           body: SafeArea(
  //             child: Stack(
  //               children: [
  //                 GoogleMap(
  //                   mapType: MapType.normal,
  //                   myLocationEnabled: true,
  //                   initialCameraPosition: _kGooglePlex,
  //                   myLocationButtonEnabled: false,
  //                   zoomGesturesEnabled: true,
  //                   zoomControlsEnabled: false,
  //                   onMapCreated: (GoogleMapController controller) {
  //                     _controllerGoogleMap.complete(controller);
  //                     newGoogleMapController = controller;

  //                     // black theme map
  //                     blackThemeGoogleMap();

  //                     locateDriverPosition();
  //                   },
  //                 ),
  //                 // UI FOR ONLINE OFFLINE DRIVER
  //                 statusText != "Now Online"
  //                     ? Container(
  //                         height: MediaQuery.of(context).size.height,
  //                         width: double.infinity,
  //                         color: Colors.black87,
  //                       )
  //                     : Container(),

  //                 //button for online offline driver
  //                 Positioned(
  //                   top: statusText != "Now Online"
  //                       ? MediaQuery.of(context).size.height * 0.46
  //                       : 25,
  //                   left: 0,
  //                   right: 0,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           if (isDriverActive != true) //offline
  //                           {
  //                             driverIsOnlineNow();
  //                             updateDriversLocationAtRealTime();

  //                             setState(() {
  //                               statusText = "Now Online";
  //                               isDriverActive = true;
  //                               buttonColor = Colors.transparent;
  //                             });

  //                             //display Toast
  //                             Fluttertoast.showToast(msg: "you are Online Now");
  //                           } else //online
  //                           {
  //                             driverIsOfflineNow();

  //                             setState(() {
  //                               statusText = "Offline";
  //                               isDriverActive = false;
  //                               buttonColor = Colors.greenAccent;
  //                             });

  //                             //display Toast
  //                             Fluttertoast.showToast(msg: "you are Offline Now");
  //                           }
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: buttonColor,
  //                           padding: const EdgeInsets.symmetric(horizontal: 18),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(26),
  //                           ),
  //                         ),
  //                         child: statusText != "Now Online"
  //                             ? Text(
  //                                 statusText,
  //                                 style: const TextStyle(
  //                                   fontSize: 16.0,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.white,
  //                                 ),
  //                               )
  //                             : const Icon(
  //                                 Icons.phonelink_ring,
  //                                 color: Colors.white,
  //                                 size: 26,
  //                               ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       : Center(child: Text('You Are Not Activated Yet!.'));
  // }

  