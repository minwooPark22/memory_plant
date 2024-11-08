import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/write_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:memory_plant_application/screens/start_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now(); // 기본적으로 오늘 날짜가 선택된 상태로 시작
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 제목
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(
            isKorean ? "날짜를 선택해주세요." : "Please select a date.",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // 캘린더
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.transparent, // 오늘 날짜의 색상을 투명하게 처리
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.black, // 오늘 날짜 텍스트 색상 유지
                ),
                selectedDecoration: BoxDecoration(
                  color: AppStyles.maindeepblue,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: true,
                rightChevronVisible: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // 하단 고정 선택 버튼
        Padding(
          padding: const EdgeInsets.all(16.0), // 전체적으로 여백 추가
          child: SizedBox(
            width: double.infinity,
            height: 60, // 버튼 높이 조정
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.maindeepblue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WritePage(
                        selected_date: _selectedDay ?? DateTime.now()),
                  ),
                );
              },
              child: Text(
                isKorean ? "선택하기" : "Select Date",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
