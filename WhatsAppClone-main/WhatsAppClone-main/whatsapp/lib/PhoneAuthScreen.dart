import 'package:flutter/material.dart';
import 'OtpVerifyScreen.dart';

class PhoneAuthScreen extends StatelessWidget {
  final phoneController = TextEditingController();

  PhoneAuthScreen({super.key});

  void sendOTP(BuildContext context) async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter phone number")),
      );
      return;
    }

    
    if (phone == "+917774835737") {
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(
            verificationId: "TEST_VERIFICATION_ID",
            isTest: true, 
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Use the Firebase test number you configured")),
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
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: 'Enter Phone Number (+91xxxxxxxxxx)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => sendOTP(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF075E54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 2,
                ),
                child: Text(
                  'Send Verification Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
