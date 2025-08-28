import 'package:fit_metrics/common/widgets/appBar.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(),
      body: const Center(child: Text('Who ever codes here :>')),
    );
  }
}
