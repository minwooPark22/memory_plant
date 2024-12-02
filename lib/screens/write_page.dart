import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/services/groq_service.dart';
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
  final CohereService _groqService = CohereService();
  bool _isLoading = false;
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
      _isSaveEnabled = _titleController.text.isNotEmpty ||
          _contentController.text.isNotEmpty;
    });
  }

  Future<void> addMemory() async {
    setState(() {
      _isLoading = true;
    });
    final newMemory = MemoryLog(
        title: _titleController.text,
        contents: _contentController.text,
        timestamp: widget.selectedDay.toString(),
        isUser: true // 작성 페이지에서 쓴 글은 무조건 isUser 가 true
        );
    context.read<MemoryLogProvider>().addMemory(newMemory);

    final botResponse = await _groqService.sendMessage(
        "${_contentController.text}   you must summary about this very shortly");
    final monthSummaryTitle = '${widget.selectedDay.month}월의 기억 요약';
    if (mounted) {
      context.read<MemoryLogProvider>().updateOrCreateMonthlySummary(
          monthSummaryTitle, botResponse, widget.selectedDay.toString());
    }
    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      context.read<NavigationProvider>().updateIndex(0); // HomePage 인덱스
      Navigator.of(context).pop();
    }
  }

  String formattedDate(BuildContext context) {
    final day = widget.selectedDay.day;
    final month = widget.selectedDay.month;
    final weekdaysKorean = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final weekdaysEnglish = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final weekday = widget.selectedDay.weekday;

    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;

    return isKorean
        ? '$month월 $day일 ${weekdaysKorean[weekday - 1]}'
        : '${weekdaysEnglish[weekday - 1]}, ${monthNames[month - 1]} $day';
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;

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
            onPressed: _isSaveEnabled && !_isLoading
                ? () async {
                    await addMemory();
                  }
                : null, //활성화 되지 않은 상태에서는 null 처리
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  )
                : Row(
              mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트 사이의 간격 최소화
              children: [
                const Icon(
                  Icons.expand_more,
                  color: Colors.grey, // 아이콘 색상
                  size: 20, // 아이콘 크기
                ),
                const SizedBox(width: 4), // 아이콘과 텍스트 사이 간격
                Text(
                  isKorean ? "저장" : "Save",
                  style: TextStyle(
                    color: _isSaveEnabled
                        ? Colors.black
                        : Colors.grey, // 비활성화 시 회색
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 아이템 왼쪽 정렬
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
            const SizedBox(height: 8), // 선과 내용 사이 간격
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
