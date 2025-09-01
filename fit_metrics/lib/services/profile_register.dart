import 'package:flutter/material.dart';
import 'package:fit_metrics/screens/home.dart';

class ProfileRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static void register(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    try {
      // TODO: registration logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
