import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../Controllers/global/global.dart';
import '../../Controllers/infoHandler/app_info.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  double ratingsNumber = 3;
  String titleStarsRating = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRatingsNumber();
    setupRatingsTitle();
  }

  getRatingsNumber() {
    setState(() {
      ratingsNumber =
          Provider.of<AppInfo>(context, listen: false).driverAverageRatings;
    });
  }

  setupRatingsTitle() {
    if (ratingsNumber <= 1 && ratingsNumber > 0.0) {
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }
    if (ratingsNumber <= 2 && ratingsNumber > 1) {
      setState(() {
        titleStarsRating = "Bad";
      });
    }
    if (ratingsNumber <= 3 && ratingsNumber > 2) {
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if (ratingsNumber <= 4 && ratingsNumber > 3) {
      setState(() {
        titleStarsRating = "Very Good";
      });
    }
    if (ratingsNumber <= 5 && ratingsNumber > 4) {
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: (ratingsNumber != 0.0)
          ? Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: Colors.white60,
              child: Container(
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 22.0,
                    ),
                    const Text(
                      "Your Ratings:",
                      style: TextStyle(
                        fontSize: 22,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    const Divider(
                      height: 4.0,
                      thickness: 4.0,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    SmoothStarRating(
                      rating: ratingsNumber,
                      allowHalfRating: false,
                      starCount: ratingsNumber.toInt(),
                      color: Colors.green,
                      borderColor: Colors.green,
                      size: 46,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      titleStarsRating,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                  ],
                ),
              ),
            )
          : Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: Colors.white60,
              child: Text('You Don\'t have a Rating right now.'),
            ),
    );
  }
}
