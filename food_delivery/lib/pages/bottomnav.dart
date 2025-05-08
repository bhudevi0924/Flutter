import 'package:app_tutorial/app_tutorial.dart';
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

class TutorialItemContent extends StatelessWidget {
  const TutorialItemContent({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Tutorial.skipAll(context),
                      child: const Text(
                        'Skip onboarding',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    const TextButton(
                      onPressed: null,
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }
}

class _BottomnavState extends State<Bottomnav> {

  late List<Widget> pages;

  late Home homePage;
  late Order orderPage;
  late Wallet walletpage;
  late Profile profilePage;

  int currentIndex=0;

  List<TutorialItem> items = [];

  final homeKey = GlobalKey();
  final orderkey = GlobalKey();
  final walletKey = GlobalKey();
  final profileKey = GlobalKey();
  
  @override
  void initState() {
    homePage=Home();
    orderPage=Order();
    walletpage=Wallet();
    profilePage=Profile();

    pages=[homePage,orderPage,walletpage,profilePage];
    initItems();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      Tutorial.showTutorial(context, items, onTutorialComplete: () {
      });
    });

    super.initState();
  }

  void initItems() {
    items.addAll({
      TutorialItem(
        globalKey: homeKey,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        borderRadius: const Radius.circular(60.0),
        shapeFocus: ShapeFocus.oval,
        radius: 90.0,
        child: const TutorialItemContent(
          title: 'Home Page',
          content: 'This is main page of the app that shows all the available foods.',
        ),
      ),
      TutorialItem(
        globalKey: orderkey,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        shapeFocus: ShapeFocus.oval,
        radius: 90.0,
        borderRadius: const Radius.circular(15.0),
        child: const TutorialItemContent(
          title: 'Order Page',
          content: 'All your orders will be shown here.',
        ),
      ),
      TutorialItem(
        globalKey: walletKey,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        shapeFocus: ShapeFocus.oval,
        radius: 90.0,
        child: const TutorialItemContent(
          title: 'Wallet',
          content: 'Add money to your wallet.',
        ),
      ),
      TutorialItem(
        globalKey: profileKey,
        shapeFocus: ShapeFocus.oval,
        radius: 90.0,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        child: const TutorialItemContent(title: "Profile", content: "Logout using this page.")
      ),
    });
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
          if(index==3) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This feature is currently disabled.')),
          );
          }
        },
        items: [
          Container(
            key: homeKey,
            alignment: Alignment.center,
            child: const Icon(Icons.home, color: Colors.white, size: 20),
          ),
          Container(
            key: orderkey,
            alignment: Alignment.center,
            child: const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
          ),
          Container(
            key: walletKey,
            alignment: Alignment.center,
            child: const Icon(Icons.wallet, color: Colors.white, size: 20),
          ),
          Container(
            key: profileKey,
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],


      ),
      body: pages[currentIndex],
    );
  }
}