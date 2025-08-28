import 'package:fit_metrics/common/widgets/Drawer.dart';
import 'package:fit_metrics/screens/profile.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  const CommonAppBar({
    Key? key,
    this.title = "Fit Metrics",
    this.icon = Icons.fitness_center,
  }) : super(key: key);
  const CommonAppBar.withTitle(
    this.title, {
    Key? key,
    this.icon = Icons.fitness_center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isProfileScreen = title == "Profile";
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white), // You can change this icon
          SizedBox(width: 8), // Space between icon and text
          Text(
            title,
            style: TextStyle(fontFamily: 'ShatellSans', color: Colors.white),
          ),
        ],
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommonDrawer()),
            );
          },
        ),
      ),
      actions: <Widget>[
        if (!isProfileScreen)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              child: CircleAvatar(
                //backgroundImage: AssetImage('assets/profile_placeholder.png'),
                radius: 20.0,
                backgroundColor: const Color.fromARGB(255, 30, 100, 255),
                child: Text(
                  'JD',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
      backgroundColor: const Color.fromARGB(255, 20, 80, 240),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
