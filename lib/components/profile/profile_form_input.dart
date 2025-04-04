import 'package:flutter/material.dart';

class ProfileFormInput extends StatelessWidget {
  final String label, hintText;
  final bool validate;
  final TextEditingController controller;

  const ProfileFormInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            // color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFC5C6CC), width: 2),

          ),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            validator: (value){
              if (validate) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your $label';
                }else{
                  RegExp phoneExp = RegExp(r'^[0-9]{10}$');
                  if (label == 'Phone Number'&&!phoneExp.hasMatch(value)) {
                    return 'Enter a valid 10 digit $label';
                  }
                }
                return null;
              }else{
                if(label == 'PF/Roll No.' && value!.isNotEmpty){
                  RegExp rollExp = RegExp(r'^[0-9]+$');
                  if (!rollExp.hasMatch(value)) {
                    return 'Enter a valid numeric PF/Roll No.';
                  }
                  return null;
                }
                return null;
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xFF8F9098)
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
