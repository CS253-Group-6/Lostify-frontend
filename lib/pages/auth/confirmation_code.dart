import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../components/auth/custom_auth_button.dart';
import '../../services/auth_api.dart';

class ConfirmationCode extends StatefulWidget {
  // get the signup details from profile form page
  final Map<String, dynamic> signUpDetails;
  const ConfirmationCode({super.key, required this.signUpDetails});

  @override
  State<ConfirmationCode> createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  // four text editing controllers for each text field
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());

  // four focus nodes
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // bool for isSubmitting
  bool _isSubmitting = false;

  // initially resend is disabled  and after 30 sec it is enabled
  bool _isResendEnabled = false; // To track if the resend button is enabled
  int _resendCountdown = 30; // Countdown timer in seconds
  Timer? _timer;

  // restart timer for 30 sec
  void _startResendTimer() {
    setState(() {
      _isResendEnabled = false;
      _resendCountdown = 30; // Reset the countdown to 30 seconds
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _isResendEnabled = true;
          timer.cancel(); // Stop the timer when countdown reaches 0
        }
      });
    });
  }

  // on loading page start timer
  @override
  void initState() {
    super.initState();
    _startResendTimer(); // Start the timer when the page loads
  }

  // dispose the timer on unmounting this page
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // change focus from fields on change
  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (index > 0 && _controllers[index].text == '') {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  // on submiting the otp
  void handleSubmit() async {
    // request data required by otp api
    var otpData = {
      'username': widget.signUpDetails['username'],
      'otp': int.tryParse(_controllers.map((e) => e.text).join()) ?? 0,
    };
    print(otpData);

    setState(() {
      _isSubmitting = true;
    });
    // call otp api with the data
    final response = await AuthApi.verifyOtp(otpData);
    print(response.body);

    // if correct otp verified
    if (response.statusCode >= 200 && response.statusCode <= 210) {
      // make call to login to save cookies
      final loginResponse = await AuthApi.login({
        'username': widget.signUpDetails['username'],
        'password': widget.signUpDetails['password'],
      });
      // if login successful
      if (loginResponse.statusCode >= 200 && loginResponse.statusCode <= 210) {
        final role = jsonDecode(loginResponse.body)['role'];
        final id = jsonDecode(loginResponse.body)['id'];
        // print('${jsonDecode(loginResponse.body)}');
        if (role != null) {
          // set submitting state as false
          setState(() {
            _isSubmitting = false;
          });
          // Parse user_id and user_role from the cookies
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Verified Successfully!',
                style: TextStyle(color: Colors.white), // Text color
              ),
              backgroundColor: Colors.blue, // Custom background color
              duration: Duration(seconds: 3), // Display duration
            ),
          );

          Navigator.of(context).pushNamed('/home', arguments: {
            'user_id': id,
            'user_role': role,
          });
        }
      } else {
        // if login failed
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error verifying otp ${jsonDecode(response.body)['message']}',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );
      }
    }else{
      // if otp is not verified
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${jsonDecode(response.body)['message']}',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );
        setState(() {
          _isSubmitting = false;
        });
    }

    // Navigator.of(context).pushReplacementNamed('/home');
  }

  // resend otp after 30 sec expiry  and restart the 30 sec timer
  void handleResendOtp() async {
    // code to handle resend otp
    if (_isResendEnabled) {
      setState(() {
          _isResendEnabled = false;
        });
      var responseSignup = await AuthApi.signUp(widget.signUpDetails);
      if (responseSignup.statusCode >= 201 && responseSignup.statusCode<=210) {
        setState(() {
          _isResendEnabled = false;
        });
        // code to handle successful response
        
        _startResendTimer();
      }
      setState(() {
        _isResendEnabled = false;
      });
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFF45BBDD).withValues(alpha: 0.4),
            image: DecorationImage(
                image: AssetImage("assets/images/Admin Login.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter confirmation code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(height: 4),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Enter the 4 digit verification code sent to your registered email.",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Color(0xFF71727A), fontSize: 14),
                            )),
                      ]),
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 50,
                          height: 50,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            onChanged: (value) =>
                                _onChanged(value, index),
                            decoration: const InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: handleResendOtp,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerRight,
                        widthFactor: 0.85,
                        child: Text(
                          "Resend OTP?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: _isResendEnabled
                                ? Color(0xFF006FFD)
                                : Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: Custombutton(
                    text: _isSubmitting ? "Submitting..." : "Continue",
                    onClick:_isSubmitting ? () {} : handleSubmit,
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
