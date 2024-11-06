import 'package:drivers_app/Controllers/assistants/assistant_methods.dart';
import 'package:drivers_app/Controllers/infoHandler/app_info.dart';
import 'package:drivers_app/Views/mainScreens/trips_history_screen.dart';
import 'package:drivers_app/widgets/history_design_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.readDriverEarnings(context);
    AssistantMethods.readTripsHistoryInformation(context);
    AssistantMethods.readDriverRatings(context);
    AssistantMethods.readCostforEvery();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: const Text(
                  'Ride History',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leadingWidth: 80,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Earnings',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        '\₹ ' +
                            Provider.of<AppInfo>(context, listen: false)
                                .driverTotalEarnings,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 2,
                height: 2,
              ),
            ],
          ),
        ),
        body: ListView.separated(
          separatorBuilder: (context, i) => const Divider(
            color: Colors.grey,
            thickness: 2,
            height: 2,
          ),
          itemBuilder: (context, i) {
            return Card(
              color: Colors.white54,
              child: HistoryDesignUIWidget(
                tripsHistoryModel: Provider.of<AppInfo>(context, listen: false)
                    .allTripsHistoryInformationList[i],
              ),
            );
          },
          itemCount: Provider.of<AppInfo>(context, listen: false)
              .allTripsHistoryInformationList
              .length,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }
}

// Container(
//           color: Colors.grey,
//           child: Column(
//             children: [
              
              //earnings
              // Container(
              //   color: Colors.black,
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 80),
              //     child: Column(
              //       children: [
              //         const Text(
              //           "your Earnings:",
              //           style: TextStyle(
              //             color: Colors.grey,
              //             fontSize: 16,
              //           ),
              //         ),
              //         const SizedBox(
              //           height: 10,
              //         ),
              //         Text(
              //           "\₹ " +
              //               double.parse(
              //                       Provider.of<AppInfo>(context, listen: false)
              //                           .driverTotalEarnings)
              //                   .toString(),
              //           style: const TextStyle(
              //             color: Colors.grey,
              //             fontSize: 60,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              //total number of trips
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
              //   },
              //   style:
              //       ElevatedButton.styleFrom(backgroundColor: Colors.white54),
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //     child: Row(
              //       children: [
              //         Image.asset(
              //           "android/images/driver.png",
              //           width: 100,
              //         ),
              //         const SizedBox(
              //           width: 6,
              //         ),
              //         const Text(
              //           "Trips Completed",
              //           style: TextStyle(
              //             color: Colors.black54,
              //           ),
              //         ),
              //         Expanded(
              //           child: Container(
              //             child: Text(
              //               Provider.of<AppInfo>(context, listen: false)
              //                   .allTripsHistoryInformationList
              //                   .length
              //                   .toString(),
              //               textAlign: TextAlign.end,
              //               style: const TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

        //     ],
        //   ),
        // ),