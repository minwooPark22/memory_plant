import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart';
import 'package:memory_plant_application/screens/write_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/my_banner_ad_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // ValueNotifier를 사용하여 상태 변경을 최적화
  final ValueNotifier<DateTime> _focusedDay =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<DateTime?> _selectedDay =
      ValueNotifier<DateTime?>(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 사용이 끝나면 ValueNotifier 해제
    _focusedDay.dispose();
    _selectedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isKorean ? "기억발전소" : "Memory Plant",
          style: const TextStyle(
              fontFamily: 'NanumFontSetup_TTF_SQUARE_ExtraBold'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.read<NavigationProvider>().updateIndex(0); // HomePage 인덱스
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyBannerAdWidget(),
          // 제목
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              isKorean ? "날짜를 선택해주세요" : "Please select a date",
              style: const TextStyle(
                fontFamily: 'NanumFontSetup_TTF_SQUARE_Extrabold',
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // 캘린더
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder<DateTime?>(
                valueListenable: _selectedDay,
                builder: (context, selectedDay, child) {
                  return TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay.value,
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      _selectedDay.value = selectedDay;
                      _focusedDay.value = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: const BoxDecoration(),
                      todayTextStyle: const TextStyle(),
                      selectedDecoration: BoxDecoration(
                        color: AppStyles.maindeepblue,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      defaultTextStyle: const TextStyle(
                        fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      ),
                      weekendTextStyle: const TextStyle(
                        fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      ),
                      holidayTextStyle: const TextStyle(
                        fontFamily: 'NanumFontSetup_TTF_SQUARE',
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
                        fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      ), // 요일 텍스트 스타일
                      weekendStyle: TextStyle(
                        color: AppStyles.maindeepblue,
                        fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      ), // 주말 텍스트 스타일
                    ),
                  );
                },
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
                          selectedDay: _selectedDay.value ?? DateTime.now()),
                    ),
                  );
                },
                child: Text(
                  isKorean ? "선택하기" : "Select Date",
                  style: const TextStyle(
                    fontFamily: 'NanumFontSetup_TTF_SQUARE_Extrabold',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
