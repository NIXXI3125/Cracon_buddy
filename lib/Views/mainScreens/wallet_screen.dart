import 'package:drivers_app/Controllers/global/global.dart';
import 'package:drivers_app/Controllers/providers/WalletProvider.dart';
import 'package:drivers_app/models/transactions_model.dart';
import 'package:drivers_app/widgets/AddMoneyPopUp.dart';
import 'package:drivers_app/widgets/WithdrawMoneyPopup.dart';
import 'package:drivers_app/widgets/list_item_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseEvent? construction;
  bool isConstruction = false;
  @override
  void initState() {
    super.initState();
    Provider.of<WalletProvider>(context, listen: false).getKeys();
    Provider.of<WalletProvider>(context, listen: false).readTransaction();
    Provider.of<WalletProvider>(context, listen: false).getWalletBalance();
    Future.delayed(
      Duration.zero,
      () async {
        construction = await dbRef.child('ExtData/driverconstruction').once();
        construction!.snapshot.value == null
            ? isConstruction = false
            : isConstruction = construction!.snapshot.value as bool;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    final TextEditingController _amountController = TextEditingController();
    List<TransactionsModel> transactions =
        Provider.of<WalletProvider>(context).transactionsList;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _height * 0.3,
                width: _width,
                alignment: Alignment.center,
                color: Colors.orange,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Available Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '₹${Provider.of<WalletProvider>(context).walletBalance}' ??
                              '₹ 0.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: _height * 0.02, horizontal: _width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 8),
                                side: const BorderSide(
                                    color: Colors.orange, width: 0.5)),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                showDragHandle: true,
                                backgroundColor: Colors.white,
                                builder: (context) {
                                  return ChangeNotifierProvider(
                                    create: (context) => WalletProvider(),
                                    child: const Addmoneypopup(),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text(
                              'Add Money',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: _height * 0.05,
                width: _width,
                color: Colors.orange[100],
                alignment: Alignment.center,
                child: const Text(
                  'Transaction History',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                height: _height * 0.67,
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 0.45,
                      color: Colors.blueGrey[300],
                      indent: _width * 0.1,
                      endIndent: _width * 0.01,
                    );
                  },
                  itemBuilder: (context, index) {
                    return ListItemWidget(
                      status: transactions[index].type,
                      amount: transactions[index].amount,
                      trID: transactions[index].id,
                      transactionDate: transactions[index].dateTime,
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
