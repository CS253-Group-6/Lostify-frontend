import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final bool showEyeIcon;
  final String label;
  const Input(
      {super.key,
      required this.textController,
      required this.hintText,
      required this.showEyeIcon,
      required this.label});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _isObscured = false;
  @override
  void initState() {
    super.initState();
    _isObscured = widget.showEyeIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFC5C6CC), width: 2)),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill this field";
          }
          if (widget.label == "Username") {
            // Check if the username contains only alphanumeric characters
            final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
            if (!alphanumericRegex.hasMatch(value.trim())) {
              return "Username must be alphanumeric";
            }
          }
          return null;
        },
        controller: widget.textController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: widget.hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            suffixIcon: widget.showEyeIcon
                ? IconButton(
                    icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null),
        style: TextStyle(
          color: Colors.black,
        ),
        obscureText: _isObscured,
      ),
    );
  }
}
