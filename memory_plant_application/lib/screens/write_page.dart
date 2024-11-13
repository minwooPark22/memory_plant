import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/home_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/services/memory_log_service.dart';

class WritePage extends StatefulWidget {
  final DateTime selectedDay;
  const WritePage({super.key, required this.selectedDay});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';
    MemoryLogService memoryLogService = MemoryLogService();

    Future<void> addMemory() async {
      final newMemory = MemoryLog(
        title: _titleController.text,
        contents: _contentController.text,
        timestamp: widget.selectedDay.toString(),
      );
      await memoryLogService.addMemory(newMemory);
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
        title: Text(
          isKorean ? "기억발전소" : "Memory Plant",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              addMemory();
            },
            child: Text(
              isKorean ? "저장" : "Save",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 선택된 날짜 표시
            Text(
              isKorean
                  ? '${widget.selectedDay.year} - ${widget.selectedDay.month} - ${widget.selectedDay.day}'
                  : '${widget.selectedDay.month} - ${widget.selectedDay.day} - ${widget.selectedDay.year}',
              style: const TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: isKorean ? "제목을 입력하세요." : "Enter the title.",
                border: InputBorder.none, // 밑줄 제거
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: isKorean ? "내용을 입력하세요." : "Write the content.",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
