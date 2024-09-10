import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../BottomNavBar.dart';
import 'information.dart';

class OTP extends StatefulWidget {
  final String verificationId;
  final int? resendToken;

  const OTP({super.key, required this.verificationId, this.resendToken});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String otpCode = '';

  void verifyOtp() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpCode,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Info()), // Change to the desired screen
            (route) => false,
      );
    } catch (e) {
      print('Failed to verify OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to verify OTP. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()),
                  (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Icon(
                Icons.sms,
                color: Colors.orange,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Verify your mobile number',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter 6-digit code sent to your mobile number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              // Display phone number for verification
              const SizedBox(height: 30),
              OtpTextField(
                numberOfFields: 6, // Increase to 6 digits for security
                borderColor: Colors.orange,
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  setState(() {
                    otpCode = code;
                  });
                },
                onSubmit: (String code) {
                  setState(() {
                    otpCode = code;
                  });
                  verifyOtp();
                },
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Try again in 28 seconds',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20), // Add some space at the bottom
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      verifyOtp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
