import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {

  String image,name,price;

  DetailPage({super.key, required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int quantity=1;
  int totalPrice=0;
  
  @override
  void initState() {
    totalPrice=int.parse(widget.price);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      margin: EdgeInsets.only(top: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: AppWidget.primaryColor, borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.arrow_back, size: 30,)
          ),
        ),
        Center(child: Image.asset(widget.image, height: MediaQuery.of(context).size.height/3,)),
        Text(widget.name, style: AppWidget.boldTextFieldStyles(),),
        SizedBox(height: 10,),
        Text("RS ${widget.price}", style: AppWidget.priceTextFieldStyles(),),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text("Sink your teeth into our juicy, flame-grilled beef patty, topped with melted cheddar cheese, crisp lettuce, fresh tomatoes, tangy pickles, and our signature burger sauce, all sandwiched between a toasted sesame seed bun. Made fresh to order and bursting with flavor—this classic never goes out of style."),
        ),
        SizedBox(height: 30,),
        Text("Quantity", style: AppWidget.simpleTextStyles(),),
        SizedBox(height: 15,),
        Row(
          children: [
            AbsorbPointer(
              absorbing: quantity<=1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    quantity--;
                    totalPrice=totalPrice-int.parse(widget.price);
                  });
                },
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: quantity>1 ? AppWidget.primaryColor: Colors.grey, 
                      borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.remove, size: 25,),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20,),
            Text("$quantity", style: AppWidget.boldTextFieldStyles(),),
            SizedBox(width: 20,),
            GestureDetector(
              onTap: () {
                setState(() {
                  quantity++;
                  totalPrice=totalPrice+int.parse(widget.price);
                });
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: AppWidget.primaryColor, borderRadius: BorderRadius.circular(20)),
                  child: Icon(Icons.add, size: 25,),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(color: AppWidget.primaryColor, borderRadius: BorderRadius.circular(15)),
              child: Center(child: Text("RS $totalPrice", style: TextStyle(fontSize: 25),)),
            ),
          ),
          SizedBox(width: 60,),
          Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
              child: Center(child: Text("Order Now", style: TextStyle(color: Colors.white, fontSize: 20),)),
            ),
          )
        ],)
      ],),
    ),);
  }
}