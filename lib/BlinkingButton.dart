import 'package:flutter/material.dart';

class MyBlinkingButton extends StatefulWidget {

  final String count;
  MyBlinkingButton({Key key, this.count}) : super(key: key);


  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  // @override
  // void initState() {
  //   _animationController =
  //       AnimationController(vsync: this, duration: Duration(seconds: 1));
  //   _animationController.repeat(reverse: true);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // return FadeTransition(
    //     opacity: _animationController,
    //     child:
    return    MaterialButton(
        onPressed: () => null,
    child: Text("Count :"+widget.count),
    color: Colors.blue,
    );
    // );
  }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }
}