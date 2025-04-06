// password_utils.dart
String? validatePasswords(String newPassword, String confirmPassword) {
  if (newPassword.isEmpty || confirmPassword.isEmpty) {
    return 'Password fields cannot be empty';
  }
  if (newPassword != confirmPassword) {
    return 'Passwords do not match!';
  }
  return null;
}
