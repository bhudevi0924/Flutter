import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_authentication/pages/candidate_form_page.dart';

const FlutterSecureStorage storage= FlutterSecureStorage();

void main() async{
  await storage.write(key:"sample",value:"sample");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Candidate Form',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: CandidateFormPage(),
    );
  }
}