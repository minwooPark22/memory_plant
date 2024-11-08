import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';

class WritePage extends StatefulWidget {
  final DateTime selected_date;
  const WritePage({super.key, required this.selected_date});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 입력 필드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[300], // 제목 배경색
              borderRadius: BorderRadius.circular(12), // 테두리 둥글게
            ),
            child: TextField(
              controller: _titleController,
              onChanged: (_) {
                setState(() {}); // 텍스트가 변경될 때마다 상태 갱신
              },
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              ),
              decoration: InputDecoration(
                hintText: isKorean ? "제목을 입력하세요." : "Please enter a title.",
                border: InputBorder.none, // 입력 필드 테두리 제거
              ),
            ),
          ),
          const SizedBox(height: 16.0), // 제목과 날짜 사이 간격
          // 선택된 날짜 표시
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[300], // 날짜 배경색
              borderRadius: BorderRadius.circular(12), // 테두리 둥글게
            ),
            child: Text(
              '${widget.selected_date.year}년 ${widget.selected_date.month}월 ${widget.selected_date.day}일',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0), // 날짜와 내용 사이 간격
          // 내용 입력 필드
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300], // 내용 배경색
                borderRadius: BorderRadius.circular(12), // 테두리 둥글게
              ),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: isKorean ? "내용을 적어보세요" : "Write the content",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0), // 내용과 버튼 사이 간격
          // 저장 버튼
          SizedBox(
            width: double.infinity,
            height: 48.0, // 버튼 높이 조정
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 버튼 색 검정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // 버튼 테두리 둥글게
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 페이지 종료
              },
              child: Text(
                isKorean ? "저장" : "Save",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12.0), // 버튼과 화면 하단 사이 여백
        ],
      ),
    );
  }
}
