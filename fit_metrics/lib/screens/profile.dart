import 'package:fit_metrics/common/widgets/appBar.dart';
import 'package:fit_metrics/common/widgets/drawer.dart';
import 'logIn.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isLoggedIn = false;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(icon: Icons.person, title: 'Profile'),
      // this needs to be back button instead of hamburger menu
      drawer: CommonDrawer(),
      body: Container(
        margin: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        child: Column(
          children: [
            Card(
              elevation: 0,
              surfaceTintColor: colorScheme.surfaceTint,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: colorScheme.tertiary, width: 0.5),
              ),
              child: Container(
                height: screenHeight * 0.1,
                width: screenWidth * 1,
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  // placeholder info
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Uncomment for profile image
                      // backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'john.doe@example.com',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        print('Edit profile pressed');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Row(
                        // for adding potential text inside edit button
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.edit, size: 16)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // profile card
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              surfaceTintColor: colorScheme.surfaceTint,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.tertiary, width: 0.5),
              ),
              child: Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      // placing all info here as two columns in
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildInfoTile(
                                  context,
                                  label: 'Age',
                                  value: '28',
                                  colorScheme: colorScheme,
                                ),
                                _buildInfoTile(
                                  context,
                                  label: 'Height',
                                  value: '180 cm',
                                  colorScheme: colorScheme,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                _buildInfoTile(
                                  context,
                                  label: 'Gender',
                                  value: 'Male',
                                  colorScheme: colorScheme,
                                ),
                                _buildInfoTile(
                                  context,
                                  label: 'Weight',
                                  value: '75 kg',
                                  colorScheme: colorScheme,
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String label,
    required String value,
    required ColorScheme colorScheme,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
