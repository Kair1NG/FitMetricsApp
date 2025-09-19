import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/common/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: Center(
        child: Text(
          'To whoever codes here :> harharhar',
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
