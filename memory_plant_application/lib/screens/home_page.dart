import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int nodata = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nodata == 0
          ? _buildEmptyState()
          : _buildMemoryList(),
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppStyles.primaryColor, // 배경 색상

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
              setState(() {
                nodata += 10;
              });
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

  Widget _buildMemoryList() {
    bool isKorean = StartPage.selectedLanguage == 'ko';

    return ListView.builder(
      itemCount: nodata,
      itemBuilder: (context, index) {
        return SwipeActionCell(
          key: Key(index.toString()),
          trailingActions: [
            SwipeAction(
              onTap: (CompletionHandler handler) async {
                final confirmed = await _confirmDelete(context);
                if (confirmed ?? false) {
                  setState(() {
                    nodata -= 1;
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text('Memory ${index + 1}'),
                subtitle: Text('This is memory item #${index + 1}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(index: index)),
                  );
                },
              ),
            ),
          ),
        );
      },
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
