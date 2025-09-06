import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../services/progress_bmi_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadProfileData();
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
            context.styledContainer(
              child: Row(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.edit, size: 16)],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            context.styledContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
