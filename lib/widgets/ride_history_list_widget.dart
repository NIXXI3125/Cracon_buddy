import 'package:drivers_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideHistoryListWidget extends StatelessWidget {
  const RideHistoryListWidget(
      {super.key,
      required this.amount,
      required this.originLocation,
      required this.destinationLocation,
      required this.trID,
      required this.isFirst,
      required this.isLast,
      required this.tripDate,
      required this.tripTime,
      this.color});
  final DateTime tripDate;
  final String tripTime;
  final String originLocation;
  final String destinationLocation;
  final double amount;
  final String trID;
  final bool isFirst;
  final bool isLast;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    List<String> date = DateFormat('dd/MM').format(tripDate).split('/');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10
      ),
      decoration: BoxDecoration(
          color: color ?? tertiary,
          borderRadius: (isFirst)
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
              : (isLast)
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : const BorderRadius.all(Radius.zero)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date[0]}/ \n${date[1]}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "android/images/destination.png",
                        height: 24,
                        width: 24,
                      ),
                      Text(
                        destinationLocation,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "android/images/origin.png",
                        height: 26,
                        width: 26,
                      ),
                      Text(
                        originLocation,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    tripTime,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text('₹$amount',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
