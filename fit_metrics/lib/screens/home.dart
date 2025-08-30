import 'package:fit_metrics/common/widgets/appBar.dart';
import 'package:fit_metrics/common/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: Center(
        child: Text(
          'To whoever codes here :>',
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
