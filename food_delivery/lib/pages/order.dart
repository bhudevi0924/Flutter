import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/service/database_methods.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/service/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  Stream? orderStream;
  String? id;

  getSharedPrefs() async {
    id = await SharedPref().getUserId();
    setState(() {
      
    });
  }

  getUserOrders() async {
    await getSharedPrefs();
    orderStream= await DatabaseMethods().getUserOrders(id!);
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    getUserOrders();
  }

  Widget allOrders() {
    return StreamBuilder(stream: orderStream, builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData ? ListView.separated(
        itemCount: snapshot.data.docs.length,
        separatorBuilder: (context, index) => SizedBox(height: 20,),
        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.docs[index];
          return Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined, color: AppWidget.primaryColor,),
                              SizedBox(width: 10,),
                              Text(ds["Address"], style: AppWidget.simpleTextStyles(),)
                            ],
                          ),
                          Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ds["FoodImage"], width: 120, height: 120, fit: BoxFit.cover,),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ds["FoodName"], style: AppWidget.boldTextFieldStyles(),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Icon(Icons.format_list_numbered, color: AppWidget.primaryColor,),
                                      SizedBox(width: 5,),
                                      Text('${ds["Quantity"]}', style: TextStyle(fontWeight: FontWeight.w600),),
                                      SizedBox(width: 40,),
                                      Icon(Icons.monetization_on_outlined, color: AppWidget.primaryColor,),
                                      SizedBox(width: 5,),
                                      Text('Rs ${ds["TotalPrice"]}', style: TextStyle(fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Text(ds["Status"],style: TextStyle(color: AppWidget.primaryColor, fontWeight: FontWeight.bold, fontSize: 20),)
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        }) : Center(child: Container(child: Text("No orders yet!", style: AppWidget.boldTextFieldStyles(),),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Orders", style: AppWidget.boldTextFieldStyles(),)
        ],),
        SizedBox(height: 10,),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  child: allOrders()),
              ],
            ),
          ),
        )
      ],),
    ),);
  }
}