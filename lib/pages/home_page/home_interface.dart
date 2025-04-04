import 'package:flutter/material.dart';

class HomeInterface extends StatelessWidget {
  const HomeInterface({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height for responsive positioning of elements
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Login_bg.png"), // Check pubspec.yaml for proper asset declaration
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: <Positioned>[
            // Positioned App Name and Tagline (above the buttons)
            Positioned(
              top: screenHeight * 0.42, // Adjust this value to move the texts higher or lower
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "LOSTIFY",
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Discover • Connect • Reclaim",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black26,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Lowered Buttons
            Positioned(
              top: screenHeight * 0.65, // Responsive vertical positioning for buttons
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CustomButton(
                    text: "Admin Login",
                    width: 300, // Adjust the width as needed
                    height: 50, // Adjust the height as needed
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin/login');
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "User Login",
                    width: 300, // Adjust the width as needed
                    height: 50,
                    onPressed: () {
                      Navigator.pushNamed(context, '/user/login');
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Not a member? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "Register now",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline, // Underline "Register now"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// Placeholder Pages for Navigation Testing
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "This is the $title page",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Custom Button Widget (Supports Size Customization)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;

  const CustomButton({
    super.key, 
    required this.text,
    required this.onPressed,
    this.width = 350,
    this.height = 60,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
