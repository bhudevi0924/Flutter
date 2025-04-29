import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/service/constants.dart';
import 'package:food_delivery/service/database_methods.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {

  String image,name,price;

  DetailPage({super.key, required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int quantity=1;
  int totalPrice=0;
  String? userName,id,email;
  Map<String, dynamic>? paymentIntent;
  
  getSharedPrefs() async {
    userName = await SharedPref().getUserName();
    id = await SharedPref().getUserId();
    email = await SharedPref().getUserEmail();
    
    setState(() {
      
    });
  }

  @override
  void initState() {
    totalPrice=int.parse(widget.price);
    getSharedPrefs();
    // TODO: implement initState
    super.initState();
  }

  handleorder() async{
    
  }

  Future<void> makePayment(String amount) async {
    try{
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Bhudevi'
        )).then((value) {});
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception: $e $s');
    }
  }

  displayPaymentSheet(String amount) async {
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        String orderId= randomAlphaNumeric(10);
        Map<String, dynamic> userOrderMap ={
          "Name": userName,
          "Id": id,
          "Email": email,
          "Quantity": quantity,
          "TotalPrice": totalPrice,
          "OrderId": orderId,
          "FoodName": widget.name,
          "FoodImage": widget.image,
          "Status": "Pending",
        };
        await DatabaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
        await DatabaseMethods().addAdminOrderDetails(userOrderMap, orderId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
              content: Text("Order Placed Successfully.",style: TextStyle(fontSize: 18),)
            )
        );
        showDialog(
          context: context, 
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green,),
                    Text("Payment Successfull.")
                  ],
                )
              ],
            ),
          )
        );
        paymentIntent=null;
      }).onError((error, stackTrace) {
        print("Error: $error $stackTrace");
      });
    } on StripeException catch(e) {
      print("Error: $e");

      showDialog(
        context: context, 
       builder: (_)=> AlertDialog(content: Text("Cancelled."),)
      );
    } catch(e) {
      print("Error $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
              content: Text("Something went wrong.",style: TextStyle(fontSize: 18),)
            )
          );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try{
      Map<String, dynamic> body ={
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response= await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  calculateAmount(String amount) {
    int amountInSmallestUnit = (int.parse(amount) * 100);
    return amountInSmallestUnit.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      height: MediaQuery.of(context).size.height,
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
          GestureDetector(
            onTap: () => makePayment(totalPrice.toString()),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text("Order Now", style: TextStyle(color: Colors.white, fontSize: 20),)),
              ),
            ),
          )
        ],)
      ],),
    ),);
  }
}