import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_plant_application/screens/write_page.dart';
import 'package:table_calendar/table_calendar.dart';

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
    return Column(
      children: [
        const Text(
          "날짜를 선택해주세요",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
        ),
        TableCalendar(
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
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.transparent, // 오늘 날짜의 색상을 투명하게 처리
            ),
            todayTextStyle: TextStyle(
              color: Colors.black, // 오늘 날짜 텍스트 색상 유지
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WritePage(
                        selected_date: _selectedDay ?? DateTime.now())),
              );
              // 일기 입력페이지로 이동
            },
            child: Text("선택하기"))
      ],
    );
  }
}
