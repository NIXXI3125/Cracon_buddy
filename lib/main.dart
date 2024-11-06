import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:drivers_app/Controllers/push_notifications/push_notification_system.dart';
import 'package:drivers_app/colors.dart';
import 'package:drivers_app/Controllers/infoHandler/app_info.dart';
import 'package:drivers_app/Views/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(backgroundFunction);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDo7-Qp3wILwxjfmizRSM8MZJqrx_OVNHE",
          appId: "1:1020996169127:android:3753acf512892ae3831a82",
          messagingSenderId: "1020996169127",
          storageBucket: "user555-3d756.appspot.com",
          projectId: "user555-3d756"));
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: "call_channel",
      channelName: "Call Channel",
      channelDescription: "Channel Calling",
      defaultColor: Colors.white,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      locked: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone,
    )
  ]);
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction action) {
      return actionHandellers(
        action,
      );
    },
  );
  FlutterForegroundTask.initCommunicationPort();
  runApp(MyMaterialApp());
}

class MyMaterialApp extends StatelessWidget {
  MyMaterialApp({super.key});

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MyApp(
      child: ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Drivers App',
          navigatorKey: navigatorKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primary),
            useMaterial3: true,
          ),
          home: const MySplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Key key = UniqueKey();
  var _dashbubble = DashBubble.instance;
  @override
  void initState() {
    super.initState();
    // Register the observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This method is called when app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        // App is in an inactive state (occurs when the app is transitioning between foreground and background)
        print("App is inactive");
        break;
      case AppLifecycleState.paused:
        // App is in the background
        print("App is in the background");
        // Call your function when app goes to background
        onAppBackground();
        break;
      case AppLifecycleState.resumed:
        // App is in the foreground
        print("App is in the foreground");
        // Call your function when app comes to the foreground
        onAppForeground();
        break;
      case AppLifecycleState.detached:
        // App is detached (generally for termination)
        print("App is detached");

        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  // Custom functions when app goes to background/foreground
  void onAppBackground() async {
    // Your code here for background tasks
    print("App moved to background, execute background functions");
    if (await _dashbubble.hasOverlayPermission()) {
      await _dashbubble.startBubble(
        bubbleOptions: BubbleOptions(
          bubbleIcon: 'icon',
          bubbleSize: 80,
          distanceToClose: 50,
          enableClose: true,
        ),
        notificationOptions: NotificationOptions(
          title: 'Cracon Buddy',
          body: 'Cracon Buddy is running in background',
          icon: 'icon',
        ),
        onTap: () async {
          print('Bubble Tapped');
          if (await _dashbubble.isRunning()) {
            try {
              FlutterForegroundTask.launchApp();
              await _dashbubble.stopBubble();
            } catch (e) {
              print(e);
            }
          }
        },
      );
    }
  }

  void onAppForeground() async {
    // Your code here for foreground tasks
    print("App moved to foreground, execute foreground functions");
    await _dashbubble.stopBubble();
  }

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
