import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignupScreen.dart';
import 'PhoneAuthScreen.dart';
import 'StatusPage.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginScreen({super.key});

  void login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields'),
      ));
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
     
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StatusPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/whatsapp.jpg', height: 200, width: 200),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter Email ...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Enter Password ...',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF075E54),
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF075E54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    minimumSize: Size(140, 30),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 2,
                  ),
                  child: Text(
                    'LogIn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                  child: Text(
                    'Need a new Account?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF075E54),
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'or LogIn using Phone Number',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 181, 199, 182),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PhoneAuthScreen()),
                    );
                  },
                  icon: Icon(Icons.phone_android, color: Colors.white),
                  label: Text(
                    'Phone Number',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF075E54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
