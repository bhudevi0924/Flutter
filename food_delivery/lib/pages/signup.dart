import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/bottomnav.dart';
import 'package:food_delivery/pages/login.dart';
import 'package:food_delivery/service/database_methods.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  String email="", name="", password="";
  bool isButtonEnabled=false, obscureText=true;
  TextEditingController nameController= new TextEditingController();
  TextEditingController emailController= new TextEditingController();
  TextEditingController passwordController= new TextEditingController();

  void _checkIfInputIsValid() {
    setState(() {
      isButtonEnabled = nameController.text.trim()!="" && emailController.text.trim() !="" && passwordController.text.trim()!="";
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(_checkIfInputIsValid);
    emailController.addListener(_checkIfInputIsValid);
    passwordController.addListener(_checkIfInputIsValid);
  }


  registration() async{
    print("called");
    if(password != "" && name!="" && email!="") {
      try{
         showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );

        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String id = randomAlpha(8);
        Map<String, dynamic> userInfoMap={
          "Name":nameController.text.trim(),
          "Email":emailController.text.trim(),
          "Id": id,
        };
        await SharedPref().saveUserEmail(email);
        await SharedPref().saveUserName(name);
        await SharedPref().saveUserId(id);
        await DatabaseMethods().addUserDetails(userInfoMap, id);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
            content: Text("Registered Successfully.",style: TextStyle(fontSize: 18),)
            ));
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Bottomnav()));
      } on FirebaseAuthException catch(e) {
          Navigator.pop(context);
        if(e.code=="weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppWidget.primaryColor,
            content: Text("Password provided is too weak.",style: TextStyle(fontSize: 18,color: Colors.black),)
            ));
        } else if(e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppWidget.primaryColor,
            content: Text("Acount already exists.", style: TextStyle(fontSize: 18,color: Colors.black),)
            ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xffffefbf),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                child: Image.asset("images/burger.png", 
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width/2,
                        ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3.5, left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0,right: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),),
                    height: MediaQuery.of(context).size.height/1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Center(
                            child: Text("SignUp", style: AppWidget.headlineTextStyles(),)
                        ),
                        
                        SizedBox(height: 15,),
                        Text("Name", style: AppWidget.signupTextFieldStyles(),),
                        SizedBox(height: 5.0,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            controller: nameController,
                          decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Name", prefixIcon: Icon(Icons.person_outlined),contentPadding: EdgeInsets.only(top: 12)),
                          ),
                        ),
                      SizedBox(height: 10,),
                        Text("Email", style: AppWidget.signupTextFieldStyles(),),
                        SizedBox(height: 5.0,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            controller: emailController,
                          decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Email", prefixIcon: Icon(Icons.email_outlined),contentPadding: EdgeInsets.only(top: 12)),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Password", style: AppWidget.signupTextFieldStyles(),),
                        SizedBox(height: 5.0,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            obscureText: obscureText,
                            controller: passwordController,
                          decoration: 
                          InputDecoration(
                            border: InputBorder.none, hintText: "Enter Password", 
                            prefixIcon: Icon(Icons.password_outlined),
                            suffixIcon: IconButton(onPressed: ()=>{setState(() {
                              obscureText= ! obscureText;
                            })}, icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility)),
                            contentPadding: EdgeInsets.only(top: 12)),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(color: isButtonEnabled? AppWidget.primaryColor: Colors.grey,borderRadius: BorderRadius.circular(20)),
                            child: GestureDetector(
                              onTap: isButtonEnabled ? () {
                                if(nameController.text!="" && emailController.text!="" && passwordController.text!=""){
                                  setState(() {
                                    name=nameController.text;
                                    email=emailController.text;
                                    password=passwordController.text;
                                  });
                                  registration();
                                }
                              }:null,
                              child: Center(
                                child: Text("Sign Up",style: AppWidget.boldTextFieldStyles(),)
                              )
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("Alreday have an account?", style: AppWidget.simpleTextStyles(),),
                          SizedBox(width: 10,),
                          GestureDetector(
                            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> LogIn())),
                            child: Text("Login", style: AppWidget.boldTextFieldStyles(),))
                        ],)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),),
        ),
      ),
    );
  }
}