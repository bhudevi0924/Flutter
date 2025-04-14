import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {

    const ContainerWidget({super.key});  // best practice to fllow (pass the key to super constructor)

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
              child: Container(
                  // color: Colors.lightBlue, // need to remove this color if we want to use color in decoration
                  padding: EdgeInsets.all(12),
                  // constraints: BoxConstraints.expand(), // takes all the height and width available
                  // constraints: BoxConstraints(minWidth: 100, maxHeight: 100), // used to mention custom width and height
                  alignment: Alignment.bottomRight,
                  width: 100,
                  height: 100,
                  // transform: Matrix4.rotationZ(0.5),  // used to chnage dimensional properties (need to give value in radians)
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid), 
                    //   borderRadius: BorderRadius.all(Radius.circular(20.0)), // removed as I'm using shape as circle
                      boxShadow: [
                          BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 4,
                              spreadRadius: 2
                          )
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.white]
                        ),
                        shape: BoxShape.circle
                  ),  //used to change the properties of the container
                  child: Text("Container Widget!")
                  ),
            ),
        );

    }
}