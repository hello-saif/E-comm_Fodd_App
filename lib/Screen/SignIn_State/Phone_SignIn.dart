import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../BottomNavBar.dart';
import 'OTP_Screen.dart';
import 'information.dart';

class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _phoneNumber = '';
  bool _isRequesting = false;

  // This will store the verificationId
  late String _verificationId;

  void _sendOtp() async {
    if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number.')),
      );
      return;
    }

    if (_isRequesting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request in progress, please wait.')),
      );
      return;
    }

    setState(() {
      _isRequesting = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user when OTP is auto-retrieved
          await _auth.signInWithCredential(credential);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Info()),
                (route) => false,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMsg = 'Verification failed. Please try again.';
          if (e.code == 'invalid-phone-number') {
            errorMsg = 'The phone number entered is invalid!';
          } else if (e.code == 'too-many-requests') {
            errorMsg =
            'You have requested too many times. Please try again later.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verificationId and navigate to OTP screen
          _verificationId = verificationId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTP(
                verificationId: verificationId,
                resendToken: resendToken,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout for $verificationId');
        },
        timeout: const Duration(seconds: 60), // Timeout set to 60 seconds
      );
    } catch (e) {
      print('Failed to send OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Please try again later.')),
      );
    } finally {
      setState(() {
        _isRequesting = false;
      });
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
              const SizedBox(height: 150),
              const Icon(
                Icons.phone,
                color: Colors.orange,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                "What's your Phone Number",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                "Mobile Number",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(),
                  ),
                ),
                initialCountryCode: 'BD', // Set default country to Bangladesh
                onChanged: (phone) {
                  setState(() {
                    _phoneNumber = phone.completeNumber; // Complete number with country code
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _phoneNumber.isEmpty ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isRequesting
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white),
                    )
                        : const Text(
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
