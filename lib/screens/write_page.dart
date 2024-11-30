import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
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
  bool _isSaveEnabled = false; // 저장 활성화 이거 추가


  @override
  void initState() {
    super.initState();
    // 제목과 내용 입력 상태를 감지
    _titleController.addListener(_updateSaveButtonState);
    _contentController.addListener(_updateSaveButtonState);
  }
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    // 제목과 내용이 둘 다 비어있지 않으면 저장 활성화
    setState(() {
      _isSaveEnabled = _titleController.text.isNotEmpty || _contentController.text.isNotEmpty;
    });
  }
  Future<void> addMemory() async {
    final newMemory = MemoryLog(
        title: _titleController.text,
        contents: _contentController.text,
        timestamp: widget.selectedDay.toString(),
        isUser: true // 작성 페이지에서 쓴 글은 무조건 isUser 가 true
    );
    context.read<MemoryLogProvider>().addMemory(newMemory);
  }

  String formattedDate(BuildContext context) {
    final day = widget.selectedDay.day;
    final month = widget.selectedDay.month;
    final weekdaysKorean = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final weekdaysEnglish = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekday = widget.selectedDay.weekday;

    final isKorean = context.watch<LanguageProvider>().currentLanguage == Language.ko;

    return isKorean
        ? '${month}월 ${day}일 ${weekdaysKorean[weekday - 1]}'
        : '${weekdaysEnglish[weekday - 1]}, ${monthNames[month - 1]} $day';
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = context.watch<LanguageProvider>().currentLanguage == Language.ko;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
        title: Text(
          formattedDate(context),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaveEnabled
              ? () {
              addMemory();
              context.read<NavigationProvider>().updateIndex(0); // HomePage 인덱스
              Navigator.of(context).pop();
            }
            : null ,    //활성화 되지 않은 상태에서는 null 처리
            child: Text(
              isKorean ? "저장" : "Save",
              style: TextStyle(
                color: _isSaveEnabled ? Colors.black : Colors.grey, // 비활성화 시 회색
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
