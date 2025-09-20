import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import '../services/progress_bmi_service.dart';
import 'login.dart';
import 'register.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double? currentBmi;
  String? currentCategory;
  double? currentHeight;
  double? currentWeight;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _checkAuthState();
  }

  void _loadProfileData() {
    final bmiService = BMIService();
    setState(() {
      currentBmi = bmiService.getCurrentBMI();
      currentCategory = bmiService.getCurrentCategory();
      currentHeight = bmiService.getCurrentHeight();
      currentWeight = bmiService.getCurrentWeight();
    });
  }

  void _checkAuthState() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        currentUser = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(icon: Icons.person, title: 'Profile'),
      body: Container(
        margin: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        child: Column(
          children: [
            // Profile/Auth Container
            context.styledContainer(
              child: currentUser != null
                  ? _buildUserProfile(colorScheme)
                  : _buildAuthOptions(colorScheme),
            ),

            // Personal Information (only show if user is authenticated)
            if (currentUser != null) ...[
              const SizedBox(height: 24),
              context.styledContainer(
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

                    // First row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildInfoTile(
                                context,
                                label: 'Age',
                                value: '19',
                                colorScheme: colorScheme,
                              ),
                              _buildInfoTile(
                                context,
                                label: 'Height',
                                value: currentHeight != null
                                    ? "${currentHeight!.toStringAsFixed(0)} cm"
                                    : 'Not set',
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
                                value: currentWeight != null
                                    ? "${currentWeight!.toStringAsFixed(0)} kg"
                                    : 'Not set',
                                colorScheme: colorScheme,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Second row for BMI
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            context,
                            label: 'BMI',
                            value: currentBmi != null
                                ? "${currentBmi!.toStringAsFixed(1)} (${currentCategory ?? '-'})"
                                : 'Not calculated',
                            colorScheme: colorScheme,
                            isLast: true,
                          ),
                        ),
                        const Expanded(child: SizedBox()), // empty slot for 2x3
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(ColorScheme colorScheme) {
    final displayName = currentUser?.displayName ?? 'User';
    final email = currentUser?.email ?? '';
    final initials = displayName.isNotEmpty
        ? displayName
              .split(' ')
              .map((name) => name[0])
              .take(2)
              .join()
              .toUpperCase()
        : email.isNotEmpty
        ? email[0].toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Text(
            initials,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              //print('Edit profile pressed');
            } else if (value == 'logout') {
              _signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 16, color: colorScheme.onSurface),
                  const SizedBox(width: 8),
                  Text('Edit', style: TextStyle(color: colorScheme.onSurface)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 16, color: colorScheme.error),
                  const SizedBox(width: 8),
                  Text('Sign Out', style: TextStyle(color: colorScheme.error)),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.more_vert,
              size: 16,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthOptions(ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(
          Icons.person_outline,
          size: 48,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to Fit Metrics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in or create an account to track your fitness progress',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => _showLoginDialog(),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRegisterDialog(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: LoginWidget(
            onLoginSuccess: () {
              Navigator.of(context).pop();
              _checkAuthState();
            },
          ),
        ),
      ),
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: RegisterWidget(
            onRegisterSuccess: () {
              Navigator.of(context).pop();
              _checkAuthState();
            },
          ),
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
