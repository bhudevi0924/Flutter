import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/service/database_methods.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  String? email, wallet, id, amount;
  Map<String, dynamic>? paymentIntent;
  TextEditingController amountController= new TextEditingController();
  bool isButtonEnabled=false;

  getSharedPrefs() async {
    email = await SharedPref().getUserEmail();
    id = await SharedPref().getUserId();
    setState(() {
      
    });
  }

  getUserWallet() async {
    await getSharedPrefs();
    QuerySnapshot querySnapshot= await DatabaseMethods().getUserWallet(email!);
    wallet = querySnapshot.docs[0]["Wallet"];
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getUserWallet();
  }

  Future<void> makePayment(String amount) async {
    try{
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        });
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Bhudevi'
        )).then((value) {});
      displayPaymentSheet(amount);
    } catch (e, s) {
      Navigator.pop(context);
      print('exception: $e $s');
    }
  }

  displayPaymentSheet(String amount) async {
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        int totalAmount = int.parse(amount) + int.parse(wallet!); 
        await DatabaseMethods().updateUserWallet(id!,totalAmount.toString());
        Navigator.pop(context);
        await getUserWallet();
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
        Navigator.pop(context);
        print("Error: $error $stackTrace");
      });
    } on StripeException catch(e) {
      Navigator.pop(context);
      print("Error: $e");

      showDialog(
        context: context, 
       builder: (_)=> AlertDialog(content: Text("Cancelled."),)
      );
    } catch(e) {
      Navigator.pop(context);
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
      String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? "";
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
      Navigator.pop(context);
      print('Error: ${e.toString()}');
    }
  }

  calculateAmount(String amount) {
    int amountInSmallestUnit = (int.parse(amount) * 100);
    return amountInSmallestUnit.toString();
  }

  Future openBox() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(width: 30,),
                  Text(
                    "Add amount",
                    style: TextStyle(
                      color: Color(0xff008080),
                      fontWeight: FontWeight.bold, fontSize: 18
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text("Add Amount"),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Amount",
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () async{
                  await makePayment(amountController.text);
                },
                child: Center(
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Color(0xff008080), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: wallet==null ? Center(child: CircularProgressIndicator()) :Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Wallet", style: AppWidget.boldTextFieldStyles(),)
        ],),
        SizedBox(height: 10,),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Image.asset("images/wallet.png", width: 80, height: 80,),
                          SizedBox(width: 50,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Your wallet", style: AppWidget.boldTextFieldStyles(),),
                              Text('RS $wallet', style: AppWidget.headlineTextStyles(),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => makePayment("100"),
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.black87,width: 2.0), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text("Rs 100", style: AppWidget.priceTextFieldStyles(),)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => makePayment("300"),
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.black87,width: 2.0), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text("Rs 300", style: AppWidget.priceTextFieldStyles(),)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => makePayment("500"),
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.black87,width: 2.0), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text("Rs 500", style: AppWidget.priceTextFieldStyles(),)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () => openBox(),
                  child: Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(color: AppWidget.primaryColor, borderRadius: BorderRadius.circular(5)),
                    child: Center(child: Text("Add Other Amount", style: AppWidget.boldTextFieldStyles(),)),
                  ),
                )
              ],
            ),
          ),
        )
      ],),
    ),);
  }
}