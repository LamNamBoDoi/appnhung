import 'package:flutter/material.dart';

class UserAttendanceCard extends StatelessWidget {
  final String username;
  final int attendedDays;
  final int totalDays;

  const UserAttendanceCard({
    required this.username,
    required this.attendedDays,
    required this.totalDays,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = attendedDays / totalDays;
    Color getColor(double p) {
      if (p >= 0.9) return Colors.green;
      if (p >= 0.7) return Colors.teal;
      if (p >= 0.5) return Colors.blue;
      if (p >= 0.3) return Colors.orange;
      return Colors.red;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.teal[100],
              child: Icon(Icons.person, color: Colors.teal[700], size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Điểm danh: $attendedDays/$totalDays ngày',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(getColor(percentage)),
                  )
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Text('${(percentage * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: getColor(percentage))),
                const SizedBox(height: 4),
                Icon(percentage >= 0.9 ? Icons.check_circle : Icons.info,
                    color: percentage >= 0.9 ? Colors.green : Colors.orange),
              ],
            )
          ],
        ),
      ),
    );
  }
}
