import 'package:flutter/material.dart';
import 'BlinkingButton.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CustomCard extends StatefulWidget {
  final String price;
  CustomCard({Key key, this.price}) : super(key: key);
  @override
  _CustomCardState createState() => _CustomCardState();
}



class _CustomCardState extends State<CustomCard> {
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
      totalCount = 0;
  }

  void _incrementCounter() {
    setState(() {
      totalCount++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (totalCount > 0) {
        totalCount--;
      }
    });
  }

  void manageMultipleStates(callback, action) {
    if (action == "1") {
      _incrementCounter();
    } else {
      _decrementCounter();
    }
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
            children: <Widget>[Text("₹ " + widget.price, style: Theme
                .of(context)
                .textTheme
                .headline2),
              MyBlinkingButton(count: totalCount.toString()),
               Padding(padding: EdgeInsets.all(20),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                new StoreConnector<int, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(int.parse(widget.price));
                    },
                    builder: (context, callback) {
                      return SizedBox(
                          width: 30, child: new FloatingActionButton(
                        onPressed: () => manageMultipleStates(callback, "1"),
                        tooltip: 'Add',
                        child: Icon(Icons.add),
                      ));
                    }),
                new StoreConnector<int, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(-1 * int.parse(widget.price));
                    },
                    builder: (context, callback) {
                      return SizedBox(
                          width: 30, child: new FloatingActionButton(
                        backgroundColor: totalCount == 0 ? Colors.grey : Colors
                            .blue,
                        onPressed: totalCount == 0 ? null : () =>
                            manageMultipleStates(callback, "-1"),
                        tooltip: 'Remove',
                        child: Icon(Icons.remove),
                      ));
                    })
              ],),)
            ])));
  }

}