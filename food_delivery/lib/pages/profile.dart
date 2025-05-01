import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/login.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  signOut() async{
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).clearSnackBars();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Loged out!"), duration: Durations.short2,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile", style: AppWidget.boldTextFieldStyles(),),
          ],
        ),
        SizedBox(height: 40,),
        IconButton(onPressed: signOut, icon: Icon(Icons.logout))
      ],),
    ),);
  }
}