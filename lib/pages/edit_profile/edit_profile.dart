// import 'package:final_project/providers/profile_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../models/user_model.dart';
// import '../../providers/user_provider.dart';
// import '../../services/auth_api.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key}) : super(key: key);

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _usernameController;
//   late TextEditingController _emailController;

//   @override
//   void initState() {
//     super.initState();
//     // Load the current user data from your provider
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final profileProvider =
//         Provider.of<ProfileProvider>(context, listen: false);
//     _usernameController = TextEditingController(text: userProvider.username);
//     // _emailController = TextEditingController(text: profileProvider.email);
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void handleUpdate() async {
//     if (_formKey.currentState!.validate()) {
//       // Create an updated user instance
//       User updatedUser = User(
//         username: _usernameController.text,
//         email: _emailController.text,
//         // Include other fields as necessary.
//       );

//       // Send updated data to your API. Make sure you have defined updateProfile in your AuthApi.
//       Map<String, dynamic> response =
//           await AuthApi.updateProfile(updatedUser.toJson());

//       if (response['statusCode'] == 200) {
//         // Optionally update the user provider with new data
//         Provider.of<UserProvider>(context, listen: false)
//             .setUserName(newUsername: _usernameController.text);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile updated successfully!")),
//         );
//         // Navigate back or perform another action
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Error updating profile: ${response['message']}")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 "Edit Profile",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: "Username",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your username";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your email";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: handleUpdate,
//                 child: const Text("Update Profile"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
