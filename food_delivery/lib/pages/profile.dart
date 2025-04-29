import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/login.dart';
import 'package:food_delivery/service/widget_support.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  signOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LogIn()));
    ScaffoldMessenger.of(context).clearSnackBars();
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