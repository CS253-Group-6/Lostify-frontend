class User{
  String id = '';
  String username,email,password;
  bool isAdmin = false;

  User({required this.username,required this.email,required this.password});
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
    };
  }
  void setIsAdmin(){
    isAdmin = true;
  }
}