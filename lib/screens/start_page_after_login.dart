import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import '../providers/chatbot_provider.dart';

class StartPageAfterLogin extends StatefulWidget {
  const StartPageAfterLogin({super.key});

  @override
  State<StartPageAfterLogin> createState() => _StartPageAfterLoginState();
}

class _StartPageAfterLoginState extends State<StartPageAfterLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    // Load providers
    context.read<MemoryLogProvider>().loadMemoryLogs();
    context.read<NameProvider>().loadName();
    context.read<ChatProvider>().loadMessages();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _getDiaryCountForDate(List<dynamic> memoryList, DateTime targetDate) {
    return memoryList.where((memory) {
      final timestamp = DateTime.parse(memory.timestamp);
      return timestamp.year == targetDate.year &&
          timestamp.month == targetDate.month &&
          timestamp.day == targetDate.day;
    }).length;
  }

  String _getMonthAbbreviation(int month) {
    const months = [
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
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = Provider.of<NameProvider>(context, listen: true);
    final memoryLogProvider =
        Provider.of<MemoryLogProvider>(context); // MemoryLogProvider 가져오기
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    final memoryCount = memoryLogProvider.memoryList
        .where((memory) => memory.isUser == true)
        .length; // 내가 쓴 메모리 개수
    final memoryList = memoryLogProvider.memoryList;
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayCount = _getDiaryCountForDate(memoryList, today);
    final yesterdayCount = _getDiaryCountForDate(memoryList, yesterday);

    // 애니메이션 길이 계산
    final maxContainerHeight = MediaQuery.of(context).size.height * 0.7;
    final animation1Height =
        (yesterdayCount * 100).clamp(0, maxContainerHeight);
    final animation2Height = (todayCount * 100).clamp(0, maxContainerHeight);

    // 애니메이션 늘어날 길이 조정정
    _animation1 =
        Tween<double>(begin: 0, end: animation1Height.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animation2 =
        Tween<double>(begin: 0, end: animation2Height.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    return GestureDetector(
      onTap: () {
        // 화면 탭 시 다음 페이지로 이동
        Navigator.pushNamed(context, "/bottomNavPage");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 125),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${DateTime.now().year}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_getMonthAbbreviation(DateTime.now().month)} ${DateTime.now().day}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isKorean
                            ? '${nameProvider.name}님 환영합니다!'
                            : "Welcome ${nameProvider.name}!",
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isKorean
                            ? "$memoryCount개의 일기" // 메모리 개수 표시
                            : "$memoryCount Memories",
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    isKorean ? "화면을 탭하여 시작하기" : "Tap the screen to start",
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Animated containers on the right
            Positioned(
              top: 0,
              right: 40,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 10,
                    height: _animation1.value,
                    color: AppStyles.primaryColor,
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 10,
                    height: _animation2.value,
                    color: AppStyles.maindeepblue,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
