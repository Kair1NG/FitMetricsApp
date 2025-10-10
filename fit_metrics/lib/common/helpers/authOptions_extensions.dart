import 'package:flutter/material.dart';
import 'package:fit_metrics/screens/login.dart';
import 'package:fit_metrics/screens/register.dart';
import 'container_extensions.dart';

void _showLoginDialog(BuildContext context, VoidCallback onLoginSuccess) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: LoginWidget(
          onLoginSuccess: () {
            Navigator.of(context).pop();
            onLoginSuccess();
          },
        ),
      ),
    ),
  );
}

void _showRegisterDialog(BuildContext context, VoidCallback onRegisterSuccess) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: RegisterWidget(
          onRegisterSuccess: () {
            Navigator.of(context).pop();
            onRegisterSuccess();
          },
        ),
      ),
    ),
  );
}

Widget buildAuthOptionBMI(
  ColorScheme colorScheme,
  BuildContext context,
  VoidCallback onAuthSuccess,
) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You need to be logged in to use the BMI Calculator.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _showLoginDialog(context, onAuthSuccess),
              style: context.styledElevatedButton().style,
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _showRegisterDialog(context, onAuthSuccess),
              style: context.styledElevatedButton().style,
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    ),
  );
}
