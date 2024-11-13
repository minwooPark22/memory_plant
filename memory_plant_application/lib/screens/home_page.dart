import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/services/memory_log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/widgets/diary_tile.dart';

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
      memoryList = memories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경색을 흰색으로 설정
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildMemoryList(),
    );
  }

  Widget _buildMemoryList() {
    return memoryList.isEmpty
        ? _buildEmptyState()
        : Align(
            alignment: Alignment.center,
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.95, // 90퍼센트 넓이 차지
              decoration: const BoxDecoration(
                color: Colors.white, // 컨테이너 배경을 흰색으로 설정
              ),
              child: ListView.builder(
                itemCount: memoryList.length,
                itemBuilder: (context, index) {
                  final memory = memoryList[index];
                  return DiaryTile(
                    memory: memory,
                    index: index,
                    onDelete: _deleteMemory,
                    onEdit: _editMemory,
                  );
                },
              ),
            ),
          );
  }

  void _deleteMemory(int index) {
    setState(() {
      memoryList.removeAt(index); // 인덱스를 사용해 삭제
    });
    memoryLogService.saveMemoryLogs(memoryList);
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

  void _editMemory(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing memory: Memory #${index + 1}')),
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;
  const DetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page for Memory #${index + 1}'),
      ),
      body: Center(
        child: Text('This is the detail view for Memory #${index + 1}.'),
      ),
    );
  }
}
