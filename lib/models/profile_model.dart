class ProfileModel {
  String name;
  String email, phoneNumber, address, designation, rollNumber;

  ProfileModel(
      {required this.name,
      required this.email,
      required this.address,
      this.designation = '',
      this.phoneNumber = '',
      this.rollNumber = ''});
}
