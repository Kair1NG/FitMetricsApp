import 'package:flutter/material.dart';

class WeeklyProgressList extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const WeeklyProgressList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: entries.length,
      shrinkWrap: true, 
      //scrolling fix?
      physics: const NeverScrollableScrollPhysics(), 
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          leading: const Icon(Icons.fitness_center, color: Colors.blue),
          title: Text("Week ${entry["week"]}"),
          trailing: Text("BMI: ${entry["bmi"]}"),
        );
      },
    );
  }
}
