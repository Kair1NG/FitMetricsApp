import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  const CommonAppBar({
    super.key,
    this.title = "FitMetrics",
    this.icon = Icons.align_horizontal_right_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final bool isProfileScreen = title == "Profile";
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, // You can change this icon,
            color: colorScheme.onPrimary,
            size: 24,
          ),
          SizedBox(width: 6),
          Text(
            title, // this title as well.
            style: TextStyle(
              fontFamily: 'ShatellSans',
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ],
      ),
      leading: Builder(
        builder: (context) {
          final bool canGoBack = Navigator.of(context).canPop();
          return IconButton(
            icon: Icon(
              canGoBack ? Icons.arrow_back : Icons.menu,
              color: colorScheme.onPrimary,
            ),
            tooltip: 'Menu',
            onPressed: () {
              if (canGoBack) {
                Navigator.of(context).pop();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
          );
        },
      ),
      actions: <Widget>[
        if (!isProfileScreen)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },

                child: Container(
                  color: colorScheme.surface,
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    //backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    radius: 18.0,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
          ),
      ],
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.surfaceTint,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0.0)),
      ),
      centerTitle: false,
      titleSpacing: 16.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
