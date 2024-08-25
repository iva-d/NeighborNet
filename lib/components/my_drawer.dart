import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // logout user
  // void logout() {
  //   FirebaseAuth.instance.signOut();
  // }
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login_register_page');
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              const SizedBox(height: 25),

              // home tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text("H O M E"),
                  onTap: () {
                    // this is already the home screen so just pop the drawer
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/home_page');
                  },
                ),
              ),

              // profile tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("P R O F I L E"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to profile page
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),


              //users tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("U S E R S"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to users page
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.forum,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("F O R U M"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to forum page
                    Navigator.pushNamed(context, '/forum_page');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("E V E N T S"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to events page
                    Navigator.pushNamed(context, '/events_page');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.report,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("R E P O R T  I S S U E"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to report issue page
                    Navigator.pushNamed(context, '/report_issue_page');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.nature_people,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("N E I G H B O R H O O D"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to neighborhood page
                    Navigator.pushNamed(context, '/neighborhood_page');
                  },
                ),
              ),
            ],
          ),

          // logout tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("L O G O U T"),
              onTap: () {
                // pop drawer
                Navigator.pop(context);

                // logout
                logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
