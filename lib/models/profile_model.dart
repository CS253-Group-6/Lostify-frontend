class ProfileModel {
  String name;
  String phoneNumber, address, designation, rollNumber;

  ProfileModel(
      {required this.name,
      required this.address,
      this.designation = '',
      this.phoneNumber = '',
      this.rollNumber = ''});
}
