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
              if ((value == null || value.isEmpty) && validate){
                return "Please enter your $label";
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
