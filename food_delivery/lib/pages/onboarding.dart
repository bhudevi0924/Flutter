import 'package:flutter/material.dart';
import 'package:food_delivery/service/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top:10.0),
        child: Column(children: [
        Image.asset("images/onboard.png", width: double.infinity, fit: BoxFit.cover,),
        Text("The Fastest Food Delivery", style: AppWidget.headlineTextStyles(),textAlign: TextAlign.center,),
        SizedBox(height: 25,),
        Text("Craving something delicious! \n Order now and get your favorites \n delivered fast!", style: AppWidget.simpleTextStyles(),textAlign: TextAlign.center,),
        SizedBox(height: 30),
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
            color: AppWidget.primaryColor, borderRadius: BorderRadius.circular(25)
          ),
          child: Center(child: Text("Get Started",style: TextStyle(fontSize: 18))),
        )
      ],),),
    );
  }
}