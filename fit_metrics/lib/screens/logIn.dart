import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //no database yet lmao
      //cant register nor log in
      appBar: CommonAppBar(icon: Icons.login, title: 'Log In'),
      body: Center(child: Text('Log In Screen')),
    );
  }
}
