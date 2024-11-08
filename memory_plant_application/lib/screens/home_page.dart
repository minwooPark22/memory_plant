import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:memory_plant_application/screens/add_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/edit_name.dart';
import 'package:memory_plant_application/widgets/setting_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/screens/read_memory_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Guest'; // Default name
  List<Map<String, dynamic>> memoryList = [];
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
    try {
      final String response = await rootBundle.loadString(
        'assets/dummy_json/dummy_memory_list.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        memoryList = data.map((item) => Map<String, dynamic>.from(item)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading JSON data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator()) : _buildMemoryList(),
    );
  }

  Widget _buildMemoryList() {
    bool isKorean = StartPage.selectedLanguage == 'ko';

    return memoryList.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            itemCount: memoryList.length,
            itemBuilder: (context, index) {
              final memory = memoryList[index];
              return SwipeActionCell(
                key: Key(index.toString()),
                trailingActions: [
                  SwipeAction(
                    onTap: (CompletionHandler handler) async {
                      final confirmed = await _confirmDelete(context);
                      if (confirmed ?? false) {
                        setState(() {
                          memoryList.removeAt(index);
                        });
                      }
                    },
                    color: Colors.red,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        Text(
                          StartPage.selectedLanguage == 'ko' ? '삭제' : 'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SwipeAction(
                    onTap: (CompletionHandler handler) async {
                      _editMemory(index);
                    },
                    color: Colors.blue,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        Text(
                          StartPage.selectedLanguage == 'ko' ? '수정' : 'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
                child: ListTile(
                  title: Text(memory['title'] ?? 'Untitled Memory'),
                  subtitle: Text(
                    memory['contents'] ?? 'No content available',
                    maxLines: 1, // 첫 번째 줄만 표시
                    overflow: TextOverflow.ellipsis, // 남은 내용은 ...으로 표시
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReadMemoryPage(memory: memory)), // ReadMemoryPage로 이동
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildEmptyState() {
    bool isKorean = StartPage.selectedLanguage == 'ko';


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppStyles.primaryColor,
            ),
            child: const Icon(
              Icons.block,
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isKorean ? "첫 기억을 추가해보세요" : "Add your first memory",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPage()),
              ); // 추가하기 누르면 AddPage로 넘어가게 함
            },
            child: Text(
              isKorean ? "추가하기" : "Add here",
              style: TextStyle(color: AppStyles.maindeepblue),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    bool isKorean = StartPage.selectedLanguage == 'ko';

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isKorean ? "삭제 확인" : "Delete Confirmation"),
          content: Text(isKorean ? "이 항목을 삭제하시겠습니까?\n이 작업은 취소할 수 없습니다." : "Are you sure you want to delete this?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(isKorean ? "아니요" : "No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(isKorean ? "예" : "Yes"),
            ),
          ],
        );
      },
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
