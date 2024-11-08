import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadMemoryPage extends StatelessWidget {
  final Map<String, dynamic> memory;
  const ReadMemoryPage({super.key, required this.memory});

  String _formatDate(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy년 MM월 dd일').format(dateTime);
    } catch (e) {
      return 'No Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 일단 비워둠
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                memory['title'] ?? 'No Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatDate(memory['timestamp'] ?? ''),
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    memory['contents'] ?? 'No Content',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
