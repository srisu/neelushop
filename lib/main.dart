import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:neelushop/CustomCard.dart';
import 'package:redux/redux.dart';

import 'CustomUpiPay.dart';


int valueComputer(int amount, dynamic value ) {
  print('oo');
  if (amount + value < 0){
    return 0;
  }
    return amount + value;
}

void main() {
  final store = new Store<int>(valueComputer, initialState: 0);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<int> store;

  const MyApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<int>(
        store: store,
        child: MaterialApp(
          // initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/home': (context) => new MyHomePage(title: "Neelu Shops",reset: true,),
            // When navigating to the "/second" route, build the SecondScreen widget.
          },
          title: 'Neelu Shop',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Neelu Shop',reset: false,),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.reset}) : super(key: key);
  final String title;
  final bool reset;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: SingleChildScrollView(child: Column(children: [
          new StoreConnector<int, String>(
              converter: (store) => store.state.toString(),
              builder: (context, total) {
                return
                  Container(child: Column(children: <Widget>[Text( this.widget.reset == true ? "₹ 0":
                    "₹" + total.toString() , style: Theme
                      .of(context)
                      .textTheme
                      .headline1,),
                    FloatingActionButton(
                    backgroundColor: int.parse(total) == 0 ? Colors.grey : Colors
                    .blue,
                      onPressed: () { int.parse(total) > 0 ?
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.3,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(25.0),
                                    topRight: const Radius.circular(25.0),
                                  ),
                                ),
                                child: new CustomUpiPay(price: total,))) : null;
                  },
                    child: Icon(Icons.payment),)
                  ]));
              }),
          SingleChildScrollView(child:
          Table(children: [TableRow(children: [TableCell(
            child: Padding(
              child: CustomCard(price: "5",),
              padding: EdgeInsets.all(25),),),
            TableCell(
              child: Padding(child: CustomCard(price: "10",),
                padding: EdgeInsets.all(25),),)
          ]),
            TableRow(children: [TableCell(
              child: Padding(child: CustomCard(price: "15",),
                padding: EdgeInsets.all(25),),),
              TableCell(
                child: Padding(child: CustomCard(price: "20",),
                  padding: EdgeInsets.all(25),),)
            ]), TableRow(children: [TableCell(
              child: Padding(child: CustomCard(price: "1",),
                padding: EdgeInsets.all(25),),),
              TableCell(
                child: Padding(child: CustomCard(price: "2",),
                  padding: EdgeInsets.all(25),),)
            ])
          ],))
        ])
        ));
  }

}