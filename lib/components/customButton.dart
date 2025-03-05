import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final String text;
  const Custombutton({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF32ADE6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        onPressed: (){},
        child: Text(
          text,
        )
    );
  }
}
