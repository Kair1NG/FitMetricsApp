import 'package:flutter/material.dart';

class WeeklyProgressList extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const WeeklyProgressList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Weekly Progress",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: entries.map((entry) {
              return ListTile(
                dense: true,
                title: Text("Week ${entry['week']}"),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "BMI: ${entry['bmi']}",
                      style: const TextStyle(color: Colors.green),
                    ),
                    Text(
                      "Weight: ${entry['weight']} kg",
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}