import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/pages/live_location_page.dart';
import 'package:food_delivery/service/database_methods.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {

  final String image,name,price;

  DetailPage({super.key, required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int quantity=1;
  int totalPrice=0;
  String? userName,id,email,address, wallet;
  Map<String, dynamic>? paymentIntent;
    TextEditingController addressController= new TextEditingController();
  
  getSharedPrefs() async {
    userName = await SharedPref().getUserName();
    id = await SharedPref().getUserId();
    email = await SharedPref().getUserEmail();
    address = await SharedPref().getUserAddress();
    
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
    totalPrice=int.parse(widget.price);
    getUserWallet();
    super.initState();
  }

  Future<void> makeCardPayment(String amount) async {
    try{
      showDialog(context: context, builder: (context) {return Center(child: CircularProgressIndicator());});
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Bhudevi'
        )).then((value) {});
      Navigator.pop(context);
      displayPaymentSheet(amount);
      Navigator.pop(context);
    } catch (e, s) {
      print('exception: $e $s');
    }
  }

  displayPaymentSheet(String amount) async {
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        handleOrder(amount);
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
        Navigator.pop(context);
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
                    "Add the address",
                    style: TextStyle(
                      color: Color(0xff008080),
                      fontWeight: FontWeight.bold, fontSize: 18
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text("Add Address"),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Address"
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () async{
                  print("address $address");
                  await SharedPref().saveUserAddress(addressController.text);
                  getSharedPrefs();
                  Navigator.pop(context);
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

  handleLocation() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LiveLocationPage()));
  }

  makeWalletpayment(String amount) async{
    handleOrder(amount);
    int userWalletAmount = int.parse(wallet!) - int.parse(amount);
    await DatabaseMethods().updateUserWallet(id!, userWalletAmount.toString());
    Navigator.pop(context);
  }

  handleOrder(String amount) async{
    try{
      showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      });
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
          "Address": address ?? addressController.text,
        };
        await DatabaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
        await DatabaseMethods().addAdminOrderDetails(userOrderMap, orderId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                  content: Text("Order Placed Successfully.",style: TextStyle(fontSize: 18),)
                )
            );
        Navigator.pop(context);
    } catch(e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                  content: Text("Somwthing went wrong! Try again.",style: TextStyle(fontSize: 18),)
                )
            );
    }
  }

  Future openPaymnetDialog(String amount) => showDialog(context: context, builder: (context) => AlertDialog(
    content: SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => makeCardPayment(amount),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(color: AppWidget.primaryColor,borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text("Pay Using Card", style: AppWidget.boldTextFieldStyles(),)),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () => makeWalletpayment(amount),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(color: AppWidget.primaryColor,borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text("Pay Using Wallet", style: AppWidget.boldTextFieldStyles(),)),
            ),
          )
        ],
      ),
    ),
  ));
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
                    IconButton(onPressed: handleLocation , icon: Icon(Icons.location_on_outlined)),
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
            onTap: () => address == null ? openBox() : openPaymnetDialog(totalPrice.toString()),
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