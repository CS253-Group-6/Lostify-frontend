import 'dart:ui';

import 'package:final_project/pages/chat/chat_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/home/action_button.dart';
import '../../../components/home/expandable_fab.dart';
import '../search_page.dart';
import 'report_tabs.dart';

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
class ReportedItemPage extends StatefulWidget {
  const ReportedItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReportedItemPageState();
}

class _ReportedItemPageState extends State<ReportedItemPage> {
  /// List of tab titles.
  final List<Widget> _tabs = const [
    Tab(
      text: 'Lost',
    ),
    Tab(text: 'Found')
  ];

  /// List of widgets corresponding to tabs in [_tabs].
  final List<Widget> _widgets = const [ItemsTab(),];

  var _isFabExpanded = false;

  @override
  Widget build(BuildContext context) {
    /// User role
    final int role = 0; // Replace with context.watch().user.role;

    /// App bar prepared outside so that size can be queried in the
    /// constructor of [PreferredSize].
    final w = AppBar(
      title: const Text('Reported items', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );

    // Tab controller
    return DefaultTabController(
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


            // Tab contents
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

            // FloatingActionButton(
            //   onPressed: () {},
            //   tooltip: 'Make a new post',
            //   child: const Icon(Icons.add),
            // ),
          ),
        ],
      ),
    );
  }
}
