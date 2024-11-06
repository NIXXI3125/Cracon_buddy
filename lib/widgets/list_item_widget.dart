import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
      {super.key,
      required this.amount,
      required this.status,
      required this.trID,
      required this.transactionDate,
      this.color});
  final DateTime transactionDate;
  final String status;
  final int amount;
  final String trID;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                status == 'credit'
                    ? Icons.call_received_rounded
                    : Icons.call_made_rounded,
                color: status == 'credit' ? Colors.green : Colors.red,
                size: 26,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (status == 'credit') ? 'Credit' : 'Debit',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      DateFormat('dd MMM,yyyy').format(transactionDate),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ((status == 'credit') ? '+' : '-') + (' ₹$amount'),
                    style: TextStyle(
                        color: (status == 'Cr') ? Colors.green : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Bal: ₹1000',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          // Container(
          //   color: Colors.grey[200],
          //   width: MediaQuery.of(context).size.width,
          //   alignment: Alignment.center,
          //   child: Text('Transaction ID: $trID',
          //       style: const TextStyle(
          //           color: Colors.black,
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500)),
          // ),
        ],
      ),
    );
  }
}
