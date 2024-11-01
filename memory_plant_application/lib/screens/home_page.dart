import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';

// 출력 텍스트 영어버전도 가능하게 하기: 완료
// 빈 리스트일 때 추가하기 하면 add로 넘어가게 하기. 이건 add 페이지에서 일기 파일로 저장 되면 변경
// dismissable을 slidable로 변경하기
// json 더미로 리스트 만드는 것 시도
// json에 제목, timestamp, content 있으면 될 듯

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int nodata = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nodata == 0
          ? _buildEmptyState() // 데이터가 없을 때 빈 상태 화면
          : _buildMemoryList(), // 데이터가 있을 때 리스트 화면
    );
  }

  // 데이터가 없을 때 보여줄 화면
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFA6D1FA), // 배경 색상
            ),
            child: const Icon(
              Icons.block,
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            StartPage.selectedLanguage == 'ko' ? '첫 기억을 추가해보세요' : 'Add your first memory',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              /* 나중에 구현되면 이걸로 변경
                // 새로운 데이터를 추가할 수 있는 페이지로 이동
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddPage()),
                );
                */

                // 
              setState(() {
                nodata += 10;
              });
            },
            child: Text(StartPage.selectedLanguage == 'ko' ? '추가하기' : 'Add Memory'),
          ),
        ],
      ),
    );
  }

  // 데이터가 있을 때 보여줄 화면 (메모리 리스트)
  Widget _buildMemoryList() {
    return ListView.builder(
      itemCount: nodata, // nodata 값에 따라 리스트 아이템 개수 결정
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(index.toString()),
          background: _buildDeleteBackground(), // 왼쪽 스와이프 시 삭제 배경
          secondaryBackground: _buildEditBackground(), // 오른쪽 스와이프 시 수정 배경
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) { // slidable로 변경하기
              // 왼쪽으로 스와이프 시 삭제 확인 메시지
              return await _confirmDelete(context);
            } else if (direction == DismissDirection.endToStart) {
              // 오른쪽으로 스와이프 시 수정 동작
              _editMemory(index);
              return false; // 수정 시 삭제하지 않음
            }
            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              setState(() {
                nodata -= 1; // 삭제된 아이템 수만큼 nodata 감소
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text('Memory ${index + 1}'),
                subtitle: Text('This is memory item #${index + 1}'),
                trailing: Icon(Icons.arrow_forward),
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

  // 왼쪽 스와이프 시 삭제 배경
  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  // 오른쪽 스와이프 시 수정 배경
  Widget _buildEditBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.blue,
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  // 삭제 확인 메시지 다이얼로그
  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StartPage.selectedLanguage == 'ko' ? '삭제 확인' : 'Confirm delete'),
          content: Text(StartPage.selectedLanguage == 'ko' ? "정말로 삭제하시겠습니까?" : 'Are you sure you want to delete it?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 취소
              },
              child: Text(StartPage.selectedLanguage == 'ko' ? "아니오" : "No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 확인
              },
              child: Text(StartPage.selectedLanguage == 'ko' ? "예" : 'Yes'),
            ),
          ],
        );
      },
    );
  }

  // 메모리 수정 동작 (여기서는 그냥 메시지를 표시함)
  void _editMemory(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing memory: Memory #${index + 1}')),
    );
  }
}

// 임시로 박스 누르면 나오는 페이지
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

