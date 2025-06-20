import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:final_project/models/profile_model.dart';
import 'package:final_project/providers/profile_provider.dart';
import 'package:final_project/pages/report_admin_pages/reported_items_page.dart';
import 'package:final_project/providers/user_provider.dart';
import 'package:final_project/services/auth_api.dart';
import 'package:final_project/services/chat_api.dart';
import 'package:final_project/services/profile_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/home/action_button.dart';
import '../../components/home/expandable_fab.dart';
import '../chat/chat_list.dart';
import '../search/search_page.dart';
import 'tabs.dart';
import '../change_password_pages/change_password.dart';

/// Home page of the application.
///
/// -----
/// #### Description:
///
/// The homepage has three main components: the app bar, display area for
/// three tabs, and a floating button to create a new post.
///
/// The app bar ([AppBar]) consists of:
///
/// * The app name (_Lostify_).
///
/// * A [TabBar] containing the names of the three tabs (_All_, _Lost_,
///   _Found_) as [Text] widgets.
///
/// The contents of the tab display area ([TabBarView]) are decided by the
/// widget loaded by the selected tab.
///
/// The floating button ([ExpandableFab]) expands into two [Row]s
/// when clicked, each of which consists of an [ActionButton] and
/// [Text] succintly stating the action corresponding to the button.
/// These buttons disambiguate between posting info about a
/// lost article versus announcing a found article.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// List of tab titles.
  final List<Widget> _tabs = const [
    Tab(
      child: Text(
        'Lost',
        style: TextStyle(color: Colors.white),
      ),
    ),
    Tab(
      child: Text(
        'Found',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  /// List of widgets corresponding to tabs in [_tabs].
  final List<Widget> _widgets = const [LostItemsTab(), FoundItemsTab()];

  var _isFabExpanded = false;

  File? profileImage;
  Future<void> getProfilePic() async {
    final profileDetails = await ProfileApi.getProfileById(
        Provider.of<UserProvider>(context, listen: false).id);
    print(profileDetails.body);
    final profilePath = jsonDecode(profileDetails.body)['image'] == ''
        ? null
        : await ProfileModel.saveProfileImage(
            base64Decode(jsonDecode(profileDetails.body)['image'] ?? ''),
            'profile ${jsonDecode(profileDetails.body)['userid']}');
    if (profilePath == null) {
      return;
    }
    print('path: ${await profilePath.exists()}');
    if (await profilePath.exists() && jsonDecode(profileDetails.body)['image'] != null) {
      
      final profileFile = await ProfileModel.saveProfileImage(
        base64Decode(jsonDecode(profileDetails.body)['image']), 
        'profile ${jsonDecode(profileDetails.body)['userid']}',
      );
      setState(() {
        print('entered set');
        profileImage = profileFile;
      });
    } else {
      setState(() {
        profileImage = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfilePic();
    // print(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).id;
    if (userId > 0) {
      ChatStateManager.listenToValue(userId);
    }
    // get the role details from Navigator args

    final roleData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {'user_id': 0, 'user_role': 0};
    // final Map<String, dynamic> roleData = jsonDecode(arguments);  // roleData = {'user_id': 2, 'user_role': '1'};

    final name = Provider.of<ProfileProvider>(context, listen: false).name;
    print(profileImage);

    /// User role
    final int role =
        roleData['user_role'] ?? 0; // Replace with context.watch().user.role;

    /// Logout
    void handleLogout() async {
      final response = await AuthApi.logout();
      if (response.statusCode >= 200 && response.statusCode < 210) {
        // Reset ProfileProvider and UserProvider
        context.read<ProfileProvider>().reset();
        context.read<UserProvider>().reset();
        // Logout successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Logout successful!',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.blue, // Custom background color
            duration: const Duration(seconds: 3), // Display duration
          ),
        );
        Navigator.pushReplacementNamed(context, '/homeInterface');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${jsonDecode(response.body)['message']}',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );

        Navigator.pushReplacementNamed(context, '/homeInterface');
      }
    }

    void showLogoutDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true, // Close dialog when tapped outside
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.logout, color: Colors.red, size: 28),
                SizedBox(width: 10),
                Text("Logout Confirmation"),
              ],
            ),
            content: Text(
              "Are you sure you want to logout?",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              // Cancel Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey[600], // Dark grey for neutral action
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                ),
                onPressed: () => Navigator.pop(context), // Close the popup
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              // Logout Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => handleLogout(), // Call API-based logout
                child: Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }

    /// App bar prepared outside so that size can be queried in the
    /// constructor of [PreferredSize].
    final w = AppBar(
      title: const Text('Lostify', style: TextStyle(color: Colors.white)),
      bottom: TabBar(tabs: _tabs),
      backgroundColor: Colors.blue,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu), // Adds the hamburger menu icon
          color: Colors.white,
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Opens the drawer
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            CupertinoIcons.search,
            size: 30,
          ),
          color: Colors.white,
          onPressed: () {
            // Navigate to the search page when the search icon is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ), // Replace SearchPage with your actual search page widget
            );
          },
        ),
      ],
    );

    // Tab controller
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && !_isFabExpanded) {
          SystemNavigator.pop();
        }
      },
      child: DefaultTabController(
        length: _tabs.length,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/new_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              // App bar wrapped with `PreferredSize`.
              appBar: PreferredSize(
                preferredSize: w.preferredSize,
                child: Stack(
                  children: [
                    IgnorePointer(
                      ignoring: _isFabExpanded,
                      child: ImageFiltered(
                        imageFilter: _isFabExpanded
                            ? ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
                            : ImageFilter.blur(),
                        child: w,
                      ),
                    ),
                    // Overlay blur effect when the FAB is expanded
                    if (_isFabExpanded)
                      Container(
                        color: Colors.white
                            .withValues(alpha: 0.5), // Brighten the background
                        child: const SizedBox
                            .expand(), // Make sure this covers the entire screen
                      ),
                  ],
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Remove 'const' here if you plan to show a dynamic name.
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (profileImage != null)
                              ? ClipOval(
                                  child: Image.file(
                                    profileImage!,
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 80,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                ),
                          const SizedBox(height: 10),
                          // Updated Text widget for the name
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            maxLines: 1, // Restrict to a single line
                            overflow: TextOverflow.ellipsis, // Add '...' if the text overflows
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text('Your lost items'),
                      onTap: () {
                        Navigator.pushNamed(context, '/lost-items');
                      },
                    ),
                    ListTile(
                      title: const Text('Your found items'),
                      onTap: () {
                        Navigator.pushNamed(context, '/found-items');
                      },
                    ),
                    if (role == 1)
                      ListTile(
                        title: const Text('Reported Items'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportedItemPage()
                            ),
                          );
                        },
                      ),
                    ListTile(
                      title: const Text('Messages'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatList()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Edit Profile'),
                      onTap: () async{
                        final result = await Navigator.pushNamed(context, '/edit-profile');
                        print('reult$result');
                        if(result == true){
                          // re-fetch profile pic
                          await getProfilePic();
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Change Password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      onTap: () => showLogoutDialog(context),
                    ),
                  ],
                ),
              ),

              body: Stack(
                children: [
                  // TabBarView wrapped with a blur effect
                  IgnorePointer(
                    ignoring: _isFabExpanded,
                    child: ImageFiltered(
                      imageFilter: _isFabExpanded
                          ? ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
                          : ImageFilter.blur(),
                      child: TabBarView(children: _widgets),
                    ),
                  ),
                  // Overlay blur effect when the FAB is expanded
                  if (_isFabExpanded)
                    Container(
                      color: Colors.white
                          .withValues(alpha: 0.5), // Brighten the background
                      child: const SizedBox
                          .expand(), // Make sure this covers the entire screen
                    ),
                ],
              ),
              // Expandable floating action button
              floatingActionButton: ExpandableFab(
                initialOpen: false,
                distance: 150.0,
                onPressed: () {
                  setState(() {
                    _isFabExpanded = !_isFabExpanded;
                  });
                },
                childWhileClosed: const Icon(Icons.add), // Icon when closed
                // Child buttons that appear when expanded
                children: <Row>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Post a lost item',
                        textScaler: TextScaler.linear(1.20),
                      ),
                      const SizedBox(width: 10.0, height: 10.0),
                      ActionButton(
                          icon: const Icon(Icons.report_problem),
                          onPressed: () {
                            Navigator.pushNamed(context, '/lost/post/1');
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Post a found item',
                        textScaler: TextScaler.linear(1.20),
                      ),
                      const SizedBox(width: 10.0, height: 10.0),
                      ActionButton(
                        icon: const Icon(Icons.archive),
                        onPressed: () {
                          Navigator.pushNamed(context, '/found/post/1');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // FloatingActionButton(
              //   onPressed: () {},
              //   tooltip: 'Make a new post',
              //   child: const Icon(Icons.add),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
