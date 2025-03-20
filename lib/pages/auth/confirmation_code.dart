import '/components/auth/custom_auth_button.dart';
import 'package:flutter/material.dart';

class ConfirmationCode extends StatefulWidget {
  const ConfirmationCode({super.key});

  @override
  State<ConfirmationCode> createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());

  void _onChanged(String value,int index){
    if(value.isNotEmpty){
      if(index < 3){
        FocusScope.of(context).requestFocus(_focusNodes[index+1]);
      }else{
        _focusNodes[index].unfocus();
      }
    }
    else if(index > 0 && _controllers[index].text == ''){
      FocusScope.of(context).requestFocus(_focusNodes[index-1]);
    }
  }

  void handleSubmit(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFF45BBDD).withOpacity(0.4),
            image: DecorationImage(
                image: AssetImage("assets/images/Admin Login.png"),
                fit: BoxFit.cover
            )
        ),
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 280,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      "Enter Confirmation code",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      ),
                    ),
                    SizedBox(height: 4,),
                    Align(
                      alignment: Alignment.center,
                        child: Text(
                          "Enter the 4 digit verification code sent to your registered email.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xFF71727A),
                              fontSize: 14
                          ),
                        )
                    ),
                    ]
                    ),
                  ),
                  SizedBox(height: 40,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 50,
                          height: 50,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            onChanged: (value) => _onChanged(value, index),
                            decoration: const InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      FractionallySizedBox(
                        alignment: Alignment.centerRight,
                        widthFactor: 0.85,
                        child: Text(
                          "Resend OTP?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Color(0xFF006FFD),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 100,),
                  Container(
                      width: 300,
                      height: 40,
                      child: Custombutton(text: "Continue",onClick: handleSubmit,)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
