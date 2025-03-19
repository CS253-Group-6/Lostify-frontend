import 'package:flutter/material.dart';

class FormDataProvider extends ChangeNotifier {
  Map<String, dynamic> _formData = {};
  Map<String, dynamic> get formData => _formData;

  void updateData(Map<String, dynamic> theForm) {
    _formData.addAll(theForm);
    // theForm.forEach((key, value) {
    //   _formData[key] = value;
    // });
    notifyListeners();  // Notify UI to refresh
  }

  void resetForm() {
    _formData = {};
    notifyListeners();
  }
}