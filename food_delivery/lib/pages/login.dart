import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/bottomnav.dart';
import 'package:food_delivery/pages/signup.dart';
import 'package:food_delivery/service/widget_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String name="", email="", password="";
  bool isButtonEnabled=false, obscureText=true;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void _checkIfInputIsValid() {
    setState(() {
      isButtonEnabled = emailController.text.trim() !="" && passwordController.text.trim()!="";
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkIfInputIsValid);
    passwordController.addListener(_checkIfInputIsValid);
  }

  userLogin() async{
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

        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnav()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: 
            Text("Loged in Successfully!", style: TextStyle(fontSize: 18),)
        ));
      } on FirebaseAuthException catch(e) {
        if(e.code=="invalid-credential") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: 
            Text("Invalid email or password", style: TextStyle(fontSize: 18),)
          ));
        }
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: 
            Text("Error! $e", style: TextStyle(fontSize: 18),)
          ));
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () =>  FocusScope.of(context).unfocus(),
        child: SafeArea(
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
                  height: MediaQuery.of(context).size.height,
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
                          SizedBox(height: 20,),
                          Center(child: Text("LogIn", style: AppWidget.headlineTextStyles(),)),
                          SizedBox(height: 15,),
                          Text("Email", style: AppWidget.signupTextFieldStyles(),),
                          SizedBox(height: 5.0,),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextField(
                              autofocus: true,
                              controller: emailController,
                            decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Email", prefixIcon: Icon(Icons.email_outlined),contentPadding: EdgeInsets.only(top: 12)),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Text("Password", style: AppWidget.signupTextFieldStyles(),),
                          SizedBox(height: 5.0,),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextField(
                              obscureText: obscureText,
                              controller: passwordController  ,
                              decoration: 
                              InputDecoration(
                                border: InputBorder.none, hintText: "Enter Password", 
                                prefixIcon: Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                onPressed: () =>{ setState(() {
                                  obscureText = ! obscureText;
                                })}, icon: Icon(obscureText ? Icons.visibility_off: Icons.visibility),),
                                contentPadding: EdgeInsets.only(top: 12)),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Text("Forgot Password?", style: AppWidget.simpleTextStyles(),)
                          ],),
                          SizedBox(height: 20,),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(color: isButtonEnabled? AppWidget.primaryColor:Colors.grey,borderRadius: BorderRadius.circular(20)),
                                  child: GestureDetector(
                                      onTap: isButtonEnabled? () {
                                          setState(() {
                                            email=emailController.text.trim();
                                            password=passwordController.text.trim();
                                          });
                                          userLogin();
                                      }: null,
                                      child: Center(
                                        child: Text("Log In",style: AppWidget.boldTextFieldStyles(),)
                                      )
                                    ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("Don't have an account?", style: AppWidget.simpleTextStyles(),),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                              },
                              child: Text("SignUp", style: AppWidget.boldTextFieldStyles(),))
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
      ),
    );
  }
  
}