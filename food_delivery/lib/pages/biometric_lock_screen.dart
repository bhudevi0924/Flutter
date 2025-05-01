import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/pages/bottomnav.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      
        final authenticated = await auth.authenticate(
          localizedReason: "Login using fingerprint.",
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: false,
          ),
        );
        if (authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Bottomnav()),
          );
        }
    } on PlatformException catch (e) {
      print("Biometric error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
