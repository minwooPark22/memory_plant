import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _Home_PageState();
}

class _Home_PageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container for the icon or image
            Container(
              width: 200, // You can adjust the size as needed
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300, // Background color for the icon
              ),
              child: Icon(
                Icons.block, // You can use any icon or replace this with an image
                size: 150,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20), // Space between icon and text
            const Text(
              '첫 기억을 추가해보세요',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20), // Space between text and button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPage()),
                );
              },
              child: const Text('추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}

