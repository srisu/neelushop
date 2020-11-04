import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:upi_pay/upi_pay.dart';

class CustomUpiPay extends StatefulWidget{
  final String price;


  CustomUpiPay({Key key, this.price}) : super(key: key);
  @override
  _CustomUpiState createState() => _CustomUpiState();

}

class _CustomUpiState extends State<CustomUpiPay> {

  Future<List<ApplicationMeta>> _appsFuture;
  String error = "";
  String success = "";

  Future<void> startPayment(ApplicationMeta app, String amount,
      BuildContext context) async {
    print("amt" + amount.toString());
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");
    try {
      String cameraScanResult = await scanner.scan();
      print(cameraScanResult);
      final start = "pa=";
      final end = "&pn";

      final startIndex = cameraScanResult.indexOf(start);
      final endIndex = cameraScanResult.indexOf(end, startIndex + start.length);

      print(cameraScanResult.substring(startIndex + start.length, endIndex)); // brown fox jumps
      var result =cameraScanResult.substring(startIndex + start.length, endIndex);
      if(!UpiPay.checkIfUpiAddressIsValid(result)){
        setState(() {
          error = "UPI Invalid";
        });
      }
      final a = await UpiPay.initiateTransaction(
        amount: amount,
        app: app.upiApplication,
        receiverName: 'Neevi CoolDrinks',
        receiverUpiAddress: result,
        transactionRef: transactionRef,
      );
      print(a);
      var b= true;
      if (a.status == UpiTransactionStatus.failure) {
      // if (!b) {
        setState(() {
          error = a.rawResponse;
          success = "";
        });
      } else {
        setState(() {
          success = "ok";
          error = "";
        });
      }
    }
    catch (err) {
      print(err);
      setState(() {
        error = "Unexpected Error, Please try again later";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    error = "";
    success = "";
    _appsFuture = Future.delayed(const Duration(seconds: 5), () {
      return UpiPay.getInstalledUpiApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<List<ApplicationMeta>>(
          future: _appsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Please try again later 😟'),);
            }
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),));
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<ApplicationMeta> meta = snapshot.data;
              if (meta == null || meta.isEmpty) {
                return Center(child: Text('No valid apps found 😨'),);
              }
              if (error != "") {
                return Center(child: FloatingActionButton(
                    child: Icon(Icons.error),
                    backgroundColor: Colors.red,
                    onPressed: () =>
                    { Navigator.of(context).pop(),}),);
              }
              if (success == "ok") {
                var deduct = this.widget.price;
                return Center(child: FloatingActionButton(
                    child: Icon(Icons.done),
                    backgroundColor: Colors.green,
                    onPressed: () =>
                    { Navigator.of(context).pop(),
                      Navigator.of(context).popAndPushNamed('/home'),

                          }));
              }
              // return GridView.count(
              //   crossAxisCount: 2,
              //   shrinkWrap: true,
              //   mainAxisSpacing: 8,
              //   crossAxisSpacing: 8,
              //   childAspectRatio: 1.6,
              //   // physics: NeverScrollableScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              return ListView.builder(
                // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: meta.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, top: 0, right: 10, bottom: 0),
                        child: InkWell(
                          splashColor: Colors.blue,
                          onTap: () =>
                              startPayment(meta[index],
                                  this.widget.price, context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.memory(
                                meta[index].icon,
                                width: 64,
                                height: 64,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                  meta[index].upiApplication.getAppName(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
            } else {
              return Center(child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),));
            }
          }
      );
    //     ],
    //   ),
    // );
  }


}
