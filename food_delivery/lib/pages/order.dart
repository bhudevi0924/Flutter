import 'package:flutter/material.dart';
import 'package:food_delivery/service/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      margin: EdgeInsets.only(top: 40),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Orders", style: AppWidget.boldTextFieldStyles(),)
        ],)
      ],),
    ),);
  }
}