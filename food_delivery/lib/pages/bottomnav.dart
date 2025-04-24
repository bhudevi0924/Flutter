import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/home.dart';
import 'package:food_delivery/pages/order.dart';
import 'package:food_delivery/pages/profile.dart';
import 'package:food_delivery/pages/wallet.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {

  late List<Widget> pages;

  late Home homePage;
  late Order orderPage;
  late Wallet walletpage;
  late Profile profilePage;

  int currentIndex=0;

  @override
  void initState() {
    homePage=Home();
    orderPage=Order();
    walletpage=Wallet();
    profilePage=Profile();

    pages=[homePage,orderPage,walletpage,profilePage];

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap:(int index) {
          ScaffoldMessenger.of(context).clearSnackBars();
          setState(() {
            currentIndex = index;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This feature is currently disabled.')),
          );
        },
        items: [
          Icon(Icons.home, color: Colors.white,size: 20,),
          Icon(Icons.shopping_bag, color: Colors.white,size: 20,),
          Icon(Icons.wallet, color: Colors.white,size: 20,),
          Icon(Icons.person, color: Colors.white,size:20)
        ]
      ),
      body: pages[currentIndex],
    );
  }
}