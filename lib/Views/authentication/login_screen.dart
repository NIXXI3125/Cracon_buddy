import 'package:drivers_app/Views/authentication/car_info_screen.dart';
import 'package:drivers_app/Views/authentication/signup_screen.dart';
import 'package:drivers_app/colors.dart';
import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/models/user_model.dart';
import 'package:drivers_app/Views/splashScreen/splash_screen.dart';
import 'package:drivers_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginDriverNow();
    }
  }

  loginDriverNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          UserModel user = UserModel.fromSnapshot(snap);
          if (firebaseUser.emailVerified) {
            if (user.car_details != null && user.driver_details != null) {
              print(user.driver_details);
              Fluttertoast.showToast(msg: "Login Successful.");
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MySplashScreen()));
            } else {
              Fluttertoast.showToast(msg: "Please Complete Your Profile.");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => CarInfoScreen()),
                  (route) => false);
            }
          } else {
            Fluttertoast.showToast(
                msg: "Email is Not Verified. Check Your Email.");
            fAuth.signOut();
            Navigator.pop(context);
          }
        } else {
          Fluttertoast.showToast(msg: "No Record Exist With This Email.");
          fAuth.signOut();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()),
              (route) => false);
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
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
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "android/images/logo1.png",
                    height: 250,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Welcome to Cracon!",
                  style: TextStyle(
                    fontSize: 30,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: textcolor, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Email",
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
                  height: 15,
                ),
                TextField(
                  controller: passwordTextEditingController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(color: textcolor, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Password",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(224, 224, 224, 1)),
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
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hoverColor,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do not have an Account? ",
                        style: TextStyle(
                          color: textcolor,
                        ),
                      ),
                      Text(
                        "SignUp Here",
                        style: TextStyle(
                            color: primary,
                            decoration: TextDecoration.underline,
                            decorationColor: primary),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (c) => SignUpScreen()),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
