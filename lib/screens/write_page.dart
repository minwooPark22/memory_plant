import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:provider/provider.dart';

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

    Future<void> addMemory() async {
      final newMemory = MemoryLog(
          title: _titleController.text,
          contents: _contentController.text,
          timestamp: widget.selectedDay.toString(),
          isUser: true // 작성 페이지에서 쓴 글은 무조건 isUser 가 true
      );
      context.read<MemoryLogProvider>().addMemory(newMemory);
    }

    String formattedDate() {
      final day = widget.selectedDay.day;
      final month = widget.selectedDay.month;
      final year = widget.selectedDay.year;

      // 요일 이름 배열 (1: Monday, 7: Sunday)
      final weekdaysKorean = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
      final weekdaysEnglish = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

      // 월 이름 배열
      final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

      // 현재 요일 계산
      final weekday = widget.selectedDay.weekday; // 1: Monday, ..., 7: Sunday

      if (isKorean) {
        return '${month}월 ${day}일 ${weekdaysKorean[weekday - 1]}';
      } else {
        return '${weekdaysEnglish[weekday - 1]}, ${monthNames[month - 1]} $day';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
        title: Text(
          formattedDate(),
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
              context.read<NavigationProvider>().updateIndex(0); // HomePage 인덱스
              Navigator.of(context).pop();
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
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: isKorean ? "제목" : "Title.",
                border: InputBorder.none, // 밑줄 제거
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            // 얇은 회색 선
            const Divider(
              color: Colors.grey, // 선 색상
              thickness: 0.5, // 선 두께
              height: 1, // 선의 높이
            ),
            const SizedBox(height: 8),
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
