import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:memory_plant_application/screens/read_memory_page.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class DiaryTile extends StatelessWidget {
  final MemoryLog memory;
  final int index;
  final Function onDelete;
  final Function(int) onEdit;

  const DiaryTile({
    super.key,
    required this.memory,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: memory.isUser == false
            ? AppStyles.primaryColor
            : Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: SwipeActionCell(
        key: Key(memory.timestamp!),
        trailingActions: [
          SwipeAction(
            onTap: (CompletionHandler handler) async {
              final confirmed = await _confirmDelete(context);
              if (confirmed ?? false) {
                onDelete(index); // 인덱스를 넘겨서 정확한 항목 삭제
              }
              else{
                await handler(false);
              }
            },
            color: Colors.red,
            content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.white),
                Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          SwipeAction(
            onTap: (CompletionHandler handler) async {
              handler(false);
              onEdit(index);
            },
            color: Colors.blue,
            content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: Colors.white),
                Text(
                  'Edit',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.transparent, // 경계 충돌 방지
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              memory.title ?? 'Untitled Memory',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              memory.contents ?? 'No content available',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadMemoryPage(memory: memory),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}