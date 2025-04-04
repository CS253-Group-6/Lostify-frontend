import 'dart:convert';
import 'dart:ui';

import 'package:final_project/services/auth_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/home/action_button.dart';
import '../../components/home/expandable_fab.dart';
import '../chat/chat_list.dart';
import '../search_page.dart';
import 'tabs.dart';
import '../change_password.dart';

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

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  /// List of tab titles.
  final List<Widget> _tabs = const [Tab(text: 'Lost'), Tab(text: 'Found')];

  /// List of widgets corresponding to tabs in [_tabs].
  final List<Widget> _widgets = const [LostItemsTab(), FoundItemsTab()];

  var _isFabExpanded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required when using AutomaticKeepAliveClientMixin
    // get the role details from Navigator args

    final roleData = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>? ?? {
      'user_id': 0,
      'user_role': '0'
    };
    // final Map<String, dynamic> roleData = jsonDecode(arguments);  // roleData = {'user_id': 2, 'user_role': '1'};

    /// User role
    final int role = int.tryParse(roleData['user_role'])??0; // Replace with context.watch().user.role;

    /// Logout
    void handleLogout() async {
      final response = await AuthApi.logout();
      if (response['statusCode'] == 200) {
        Navigator.pushReplacementNamed(context, '/user/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response['message']}')));

        // TODO: remove this navigate in failed
        Navigator.pushReplacementNamed(context, '/user/login');
      }
    }

    /// App bar prepared outside so that size can be queried in the
    /// constructor of [PreferredSize].
    final w = AppBar(
    title: const Text('Lostify', style: TextStyle(color: Colors.white)),
    bottom: TabBar(
      tabs: _tabs,
      labelColor: Colors.white, // Color for the selected tab
      unselectedLabelColor: Colors.white70, // Color for unselected tabs
      indicatorColor: Colors.white, // Color for the indicator below the selected tab
    ),
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
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isFabExpanded) {
          // Handle the pop event here if needed
          // For example, you can navigate to a different page or show a message
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
                backgroundColor: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Remove 'const' here if you plan to show a dynamic name.
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage('assets/images/profile_picture.png'),
                          ),
                          const SizedBox(height: 10),
                          // Replace 'John Doe' with the actual name or a variable holding it.
                          Text(
                            'John Doe',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
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
                        onTap: () {},
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
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Change Password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      onTap: handleLogout,
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
                childWhileClosed: const Icon(
                  Icons.add,
                  color: Colors.white, // Set the icon color to white
                  size: 30, // Adjust size if needed
                ),                // Child buttons that appear when expanded
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
                          icon: const Icon(CupertinoIcons.search),
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
                        icon: const Icon(CupertinoIcons.speaker_1_fill),
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
  @override
  bool get wantKeepAlive => true; 
}
