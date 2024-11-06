import 'package:intl/intl.dart';

class TransactionsModel {
  final String id;
  final String type;
  final amount;
  final DateTime dateTime;

  TransactionsModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.dateTime,
  });

  factory TransactionsModel.fromMap(var map) {
    return TransactionsModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      dateTime: DateFormat('yyyy-MM-dd – kk:mm:ss').parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'timestamp': dateTime,
    };
  }
}
