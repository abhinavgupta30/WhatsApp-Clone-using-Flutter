import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'StatusPage.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String verificationId;
  final bool isTest;

  const OtpVerifyScreen({super.key, required this.verificationId, this.isTest = false});

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isTest) {
      
      otpController.text = "654321";

      
      Future.delayed(Duration(seconds: 30), () {
        if (mounted && otpController.text == "654321") {
          verifyOTP(context);
        }
      });
    }
  }

  void verifyOTP(BuildContext context) async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter OTP")),
      );
      return;
    }

    try {
      if (widget.isTest) {
        if (otp == "654321") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => StatusPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid Test OTP")),
          );
        }
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otp,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => StatusPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Enter Verification Code ...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => verifyOTP(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF075E54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 2,
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Code Sent', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
