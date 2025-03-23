
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen height for responsive positioning of elements
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.png"), // Check pubspec.yaml for proper asset declaration
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
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
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Discover Connect Reclaim",
                    style: TextStyle(
                      fontSize: 20,
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin_login');
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "User Login",
                    onPressed: () {
                      Navigator.pushNamed(context, '/user_login');
                    },
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Not a member? Register now",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contact Us Button at Bottom Center
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: CustomButton(
                  text: "Contact Us",
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact');
                  },
                  width: 110,
                  height: 28,
                  fontSize: 10,
                ),
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
  const PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "This is the $title page",
          style: TextStyle(fontSize: 24),
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
