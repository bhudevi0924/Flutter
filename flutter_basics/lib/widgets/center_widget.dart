import 'package:flutter/material.dart';

class CenterWidget extends StatelessWidget{

  const CenterWidget({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        // heightFactor: 2, // multiplies with the height of the text and places at it's height
        // widthFactor: 2, // multiplies with the width of the text and places at it's width
        child: Text("Ceneter Wiget! Used to place the items at the center.")
        ),
      ); // wrap with center
  }
}