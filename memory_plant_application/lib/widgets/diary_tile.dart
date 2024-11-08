/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memory_plant_application/screens/read_memory_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

쿠퍼티노 디자인 시발
class DiaryTile extends StatelessWidget {
  final Map<String, dynamic> memory;
  final int index;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const DiaryTile({
    Key? key,
    required this.memory,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Slidable(
        key: Key(index.toString()),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(index),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: CupertinoIcons.pencil,
              label: StartPage.selectedLanguage == 'ko' ? '수정' : 'Edit',
            ),
            SlidableAction(
              onPressed: (context) async {
                final confirmed = await _confirmDelete(context);
                if (confirmed ?? false) {
                  onDelete(index);
                }
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: CupertinoIcons.delete,
              label: StartPage.selectedLanguage == 'ko' ? '삭제' : 'Delete',
            ),
          ],
        ),
        child: CupertinoListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          title: Text(memory['title'] ?? 'Untitled Memory'),
          subtitle: Text(
            memory['contents'] ?? 'No content available',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(CupertinoIcons.forward),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ReadMemoryPage(memory: memory),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    bool isKorean = StartPage.selectedLanguage == 'ko';

    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(isKorean ? "삭제 확인" : "Delete Confirmation"),
          content: Text(isKorean
              ? "이 항목을 삭제하시겠습니까?\n이 작업은 취소할 수 없습니다."
              : "Are you sure you want to delete this?"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(isKorean ? "아니요" : "No"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              isDestructiveAction: true,
              child: Text(isKorean ? "예" : "Yes"),
            ),
          ],
        );
      },
    );
  }
}

class CupertinoListTile extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CupertinoListTile({
    Key? key,
    this.contentPadding,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: contentPadding ?? EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  if (subtitle != null) ...[
                    SizedBox(height: 4.0),
                    subtitle!,
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}*/
//원래 스타일
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:memory_plant_application/screens/read_memory_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class DiaryTile extends StatelessWidget {
  final Map<String, dynamic> memory;
  final int index;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const DiaryTile({
    Key? key,
    required this.memory,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: Key(index.toString()),
      trailingActions: [
        SwipeAction(
          onTap: (CompletionHandler handler) async {
            final confirmed = await _confirmDelete(context);
            if (confirmed ?? false) {
              onDelete(index);
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
            onEdit(index);
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          title: Text(memory['title'] ?? 'Untitled Memory'),
          subtitle: Text(
            memory['contents'] ?? 'No content available',
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
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    bool isKorean = StartPage.selectedLanguage == 'ko';

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isKorean ? "삭제 확인" : "Delete Confirmation"),
          content: Text(isKorean
              ? "이 항목을 삭제하시겠습니까?\n이 작업은 취소할 수 없습니다."
              : "Are you sure you want to delete this?"),
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
}