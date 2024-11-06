import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/models/trips_history_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum HomeScreenStateStatus { initial, loading, loaded, error }

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenStateStatus state = HomeScreenStateStatus.initial;
  String _errorMessage = '';
  double WalletBalance = 0.0;
  List<TripsHistoryModel> tripsHistory = [];
  List<String> tripsKeysList = [];

  void getWalletBalance() {
    state = HomeScreenStateStatus.loading;
    dbRef
        .child('drivers/${currentFirebaseUser!.uid}')
        .child('Wallet')
        .once()
        .then(
      (DatabaseEvent snapshot) {
        if (snapshot.snapshot.value != null) {
          print('wallet: ${snapshot.snapshot.value}');
          WalletBalance = double.parse(snapshot.snapshot.value.toString());
          state = HomeScreenStateStatus.loaded;
          notifyListeners();
        } else {
          _errorMessage = 'Error fetching wallet balance';
          state = HomeScreenStateStatus.error;
          notifyListeners();
        }
      },
    );
  }

  void getAllTrips() async {
    state = HomeScreenStateStatus.initial;
    DatabaseEvent snap = await dbRef
        .child("drivers/${currentFirebaseUser!.uid}/tripsHistory")
        .once();

    if (snap.snapshot.value != null) {
      state = HomeScreenStateStatus.loading;
      Map keysTripsId = snap.snapshot.value as Map;
      int overAllTripsCounter = keysTripsId.length;
      keysTripsId.forEach((key, value) {
        tripsKeysList.add(key);
      });
    }
    tripsHistory.clear();
    if (tripsKeysList.isNotEmpty) {
      for (int tripkey = 0; tripkey < tripsKeysList.length; tripkey++) {
        DatabaseEvent snapshot = await dbRef
            .child("All Ride Requests")
            .child(tripsKeysList[tripkey])
            .once();

        if (snapshot.snapshot.value != null) {
          tripsHistory
              .add(TripsHistoryModel.fromJson(snap.snapshot.value as Map));
        }
      }
      state = HomeScreenStateStatus.loaded;
    }
    notifyListeners();
  }
}
