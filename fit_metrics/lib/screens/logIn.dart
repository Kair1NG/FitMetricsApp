import 'package:fit_metrics/common/widgets/appBar.dart';
import 'register.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(icon: Icons.login, title: 'Log In'),
      body: Center(child: Text('Log In Screen')),
    );
  }
}
