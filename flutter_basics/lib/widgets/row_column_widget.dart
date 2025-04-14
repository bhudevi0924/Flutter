import 'package:flutter/material.dart';

class RowColumnWidget extends StatelessWidget{

  const RowColumnWidget({super.key});

  Widget _button(String label) {
    return ElevatedButton(onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
    ), 
    child: Text(label),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 300,
        color: Colors.blue,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,  // x axis size (row size) (by default it is max)
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,  // y axis for row
              textDirection: TextDirection.rtl,    // used to change the direction of the text in row
              children: [_button("Row 1"), _button("Row 2"), _button("Row 3")],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,  //y axis for column
                crossAxisAlignment: CrossAxisAlignment.center,     //x axis fro row
                children: [_button("Column 1"), _button("Column 2"), _button("Column 3")],
              ),
            ),
            Wrap(
              direction: Axis.horizontal,         //used to specify the direction
              // alignment: WrapAlignment.spaceAround,
              runSpacing: 10,
              spacing: 100,
              children: [_button("Wrap 1"), _button("Wrap 2"), _button("Wrap 3"),_button("Wrap 4"), _button("Wrap 5"), _button("Wrap 6")],
            )
          ],
        )
      ),
    );
  }
}