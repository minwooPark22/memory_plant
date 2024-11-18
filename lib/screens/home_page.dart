import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/edit_memory_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/services/memory_log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/widgets/diary_tile.dart';
import 'package:intl/intl.dart'; // 날짜 처리를 위한 패키지

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Guest'; // Default name
  List<MemoryLog> memoryList = [];
  MemoryLogService memoryLogService = MemoryLogService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadMemoryData();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest';
      isLoading = false;
    });
  }

  Future<void> _loadMemoryData() async {
    final memories = await memoryLogService.loadMemoryLogs();

    setState(() {
      memoryList = memories
      ..sort((a, b) {
        final dateA = DateTime.parse(a.timestamp!);
        final dateB = DateTime.parse(b.timestamp!);

        return dateB.compareTo(dateA); // timestamp 기준 내림차순 정렬
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildMemoryList(),
    );
  }

  Widget _buildMemoryList() {
    if (memoryList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      itemCount: memoryList.length,
      itemBuilder: (context, index) {
        final memory = memoryList[index];
        final currentMonth = _getMonthFromTimestamp(memory.timestamp!);

        // 첫 번째 항목이거나, 이전 항목과 월이 다르면 구분선 추가
        bool showMonthSeparator = (index == 0) ||
            (_getMonthFromTimestamp(memoryList[index - 1].timestamp!) !=
                currentMonth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showMonthSeparator) _buildMonthSeparator(currentMonth),
            DiaryTile(
              memory: memory,
              index: index,
              onDelete: _deleteMemory,
              onEdit: _editMemory,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8), // 항목 간 간격
    );
  }

  void _deleteMemory(int index) {
    setState(() {
      memoryList.removeAt(index);
    });
    memoryLogService.saveMemoryLogs(memoryList);
  }

  void _editMemory(int index) async {
    final updatedMemory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMemoryPage(memory: memoryList[index]),
      ),
    );

    if (updatedMemory != null && updatedMemory is MemoryLog) {
      setState(() {
        memoryList[index] = updatedMemory; // 수정된 데이터 반영
      });
      memoryLogService.saveMemoryLogs(memoryList); // 수정된 데이터를 저장
    }
  }

  Widget _buildEmptyState() {
    bool isKorean = StartPage.selectedLanguage == 'ko';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/No_memory.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 20),
          Text(
            isKorean ? "첫 기억을 추가해보세요" : "Add your first memory",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper: 구분선 위에 표시할 월 반환
  String _getMonthFromTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat.yMMMM().format(date); // 예: "November 2024"
  }

  // Helper: 월별 구분선 위젯 생성
  Widget _buildMonthSeparator(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        month,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
