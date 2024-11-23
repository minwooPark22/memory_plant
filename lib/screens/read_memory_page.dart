import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:provider/provider.dart';

class ReadMemoryPage extends StatelessWidget {
  final MemoryLog memory;
  const ReadMemoryPage({super.key, required this.memory});

  String _formatDateKorean(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy년 MM월 dd일').format(dateTime);
    } catch (e) {
      return 'No Date';
    }
  }

  String _formatDateEnglish(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('MM-dd-yyyy').format(dateTime);
    } catch (e) {
      return 'No Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isKorean ? "기억 읽기" : "Read memory",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isKorean
                    ? _formatDateKorean(memory.timestamp!)
                    : _formatDateEnglish(memory.timestamp!),
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              memory.title ?? "No title",
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Text(
                memory.contents ?? "No contents",
                maxLines: null,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
