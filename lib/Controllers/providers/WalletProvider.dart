import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/models/transactions_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum WalletProviderState {
  initial,
  loading,
  loaded,
  error,
}

class WalletProvider extends ChangeNotifier {
  WalletProviderState state = WalletProviderState.initial;
  var walletBalance;
  Razorpay _razorpay = Razorpay();
  String razorpay_key = '';
  List<TransactionsModel> transactionsList = [];

  void getKeys() async {
    await FirebaseDatabase.instance
        .ref()
        .child('ExtData')
        .child('Pay')
        .child('RZP-KEY')
        .get()
        .then((DataSnapshot snapshot) {
      print('keys: ${snapshot.value}');
      razorpay_key = snapshot.value.toString();
      notifyListeners();
    });
  }

  void getWalletBalance() async {
    DatabaseEvent wallet =
        await dbRef.child('drivers/${currentFirebaseUser!.uid}/Wallet').once();
    print('wallet: ${wallet.snapshot.value}');
    if (wallet.snapshot.value == null) {
      dbRef.child('drivers/${currentFirebaseUser!.uid}/Wallet').set(0.0);
    } else {
      walletBalance = wallet.snapshot.value;
    }
    state = WalletProviderState.loaded;
    notifyListeners();
  }

  void readTransaction() async {
    DatabaseEvent transaction = await dbRef
        .child('drivers')
        .child(currentFirebaseUser!.uid)
        .child('Transactions')
        .once();

    // transactions is a list of map

    Map<dynamic, dynamic> transations =
        transaction.snapshot.value as Map<dynamic, dynamic>;
    transactionsList = transations.entries
        .map((entry) => TransactionsModel.fromMap(entry.value))
        .toList();
  }

  void addMoneyToWallet(double amount, BuildContext context) {
    openRazorPayGateway(amount);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse data) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Successful"),
        ),
      );
      print('Wallet Balance: $walletBalance');
      dbRef
          .child('drivers')
          .child(currentFirebaseUser!.uid)
          .child('Wallet')
          .set(walletBalance + amount);
      dbRef
          .child('drivers')
          .child(currentFirebaseUser!.uid)
          .child('Transactions')
          .child(data.paymentId!)
          .set({
        'amount': amount,
        'type': 'credit',
        'timestamp': DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now()),
        'id': data.paymentId,
      });
      readTransaction();
      getWalletBalance();
      state = WalletProviderState.loaded;
      notifyListeners();
    });
    Future.delayed(const Duration(seconds: 2), () {
      state = WalletProviderState.loaded;
      notifyListeners();
    });
  }

  void withdrawMoneyFromWallet() {
    // This is a dummy function that simulates an API call
    Future.delayed(Duration(seconds: 2), () {
      state = WalletProviderState.loaded;
      notifyListeners();
    });
  }

  void openRazorPayGateway(double amount) {
    var options = {
      'key': 'rzp_live_rEfUjTSC0CXJOk',
      'amount': amount,
      'currency': 'INR',
      'description': 'Add money to wallet',
      'prefill': {'email': currentFirebaseUser?.email.toString()},
    };
    _razorpay.open(options);
  }
}
