import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/primary_box.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';

class StartPageAfterLogin extends StatefulWidget {
  const StartPageAfterLogin({super.key});

  @override
  State<StartPageAfterLogin> createState() => _StartPageAfterLoginState();
}

class _StartPageAfterLoginState extends State<StartPageAfterLogin> {
  double primaryBoxHeight = 0.30;
  double verticalDragOffset = 0;
  double primaryBoxTopPosition = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        primaryBoxTopPosition = MediaQuery.of(context).size.height * 0.00;
      });
    });
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = Provider.of<NameProvider>(context);
    final memoryLogProvider =
        Provider.of<MemoryLogProvider>(context); // MemoryLogProvider 가져오기
    final isKorean = StartPage.selectedLanguage == 'ko';
    final memoryCount = memoryLogProvider.memoryList.length; // 메모리 개수

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          // 아래에서 위로 드래그 시 verticalDragOffset이 증가
          verticalDragOffset += details.delta.dy; // 아래에서 위로 드래그하면 delta.dy는 음수
          verticalDragOffset = verticalDragOffset.clamp(
              0, MediaQuery.of(context).size.height * 0.3);
        });
      },
      onVerticalDragEnd: (details) {
        if (verticalDragOffset > 150) {
          setState(() {
            primaryBoxTopPosition =
                MediaQuery.of(context).size.height * 0.0; // 상자가 최종 위치로 이동
            verticalDragOffset = 0; // 드래그 상태 초기화
          });
          Navigator.pushNamed(context, "/bottomNavPage");
        } else {
          setState(() {
            verticalDragOffset = 0; // 원래 상태로 복귀
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppStyles.maindeepblue,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              top: primaryBoxTopPosition - verticalDragOffset,
              left: 0,
              right: 0,
              child: PrimaryBox(
                  height:
                      MediaQuery.of(context).size.height * primaryBoxHeight),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${DateTime.now().year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 63,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_getMonthAbbreviation(DateTime.now().month)} ${DateTime.now().day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 55,
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                            : "$memoryCount Journals",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    isKorean ? "아래로 스와이프하여 시작하기" : "Swipe up to start",
                    style: TextStyle(
                      color: AppStyles.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
