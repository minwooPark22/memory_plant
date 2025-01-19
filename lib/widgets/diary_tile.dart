import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/screens/edit_memory_page.dart';
import 'package:memory_plant_application/screens/read_memory_page.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:intl/intl.dart';

class DiaryTile extends StatelessWidget {
  final MemoryLog memory;
  final int index;

  const DiaryTile({
    super.key,
    required this.memory,
    required this.index,
  });

  String _formatDate(String timestamp) {
    final date = DateTime.parse(timestamp); // timestamp를 DateTime으로 변환
    return DateFormat('MM/dd').format(date); // MM/dd 형식으로 변환
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: memory.isUser == false ? AppStyles.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
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
              final confirmed = await _confirmDelete(context, isKorean);
              if (confirmed ?? false) {
                if (context.mounted) {
                  context.read<MemoryLogProvider>().deleteMemory(memory);
                }
              } else {
                await handler(false);
              }
            },
            color: Colors.red,
            content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentSystemIcons.ic_fluent_delete_regular,
                  color: Colors.white,
                  size: 45,
                ),
              ],
            ),
          ),
          SwipeAction(
            onTap: (CompletionHandler handler) async {
              handler(false);
              final updatedMemory = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMemoryPage(memory: memory),
                ),
              );

              if (updatedMemory != null && updatedMemory is MemoryLog) {
                if (context.mounted) {
                  // mounted 체크
                  context
                      .read<MemoryLogProvider>()
                      .editMemory(memory, updatedMemory);
                }
              }
            },
            color: AppStyles.maindeepblue,
            content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FluentSystemIcons.ic_fluent_edit_regular,
                    color: Colors.white, size: 45),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (memory.isUser!) // memory.isUser가 true일 때만 날짜 텍스트를 렌더링
                  Text(
                    _formatDate(memory.timestamp!), // 날짜 표시
                    style: const TextStyle(
                      fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                Text(
                  memory.title ?? 'Untitled Memory', // 제목
                  style: const TextStyle(
                    fontFamily: 'NanumFontSetup_TTF_SQUARE_Extrabold',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              memory.contents ?? 'No content available',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: 'NanumFontSetup_TTF_SQUARE', color: Colors.black),
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

  Future<bool?> _confirmDelete(BuildContext context, bool isKorean) async {
    return showDialog<bool>(
      // 삭제 확인 다이얼로그
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isKorean ? "삭제 확인" : "Delete Confirmation",
            style: const TextStyle(
                fontFamily: 'NanumFontSetup_TTF_SQUARE_Extrabold'),
          ),
          content: Text(
              isKorean
                  ? "정말로 삭제하시겠습니까?"
                  : "Are you sure you want to delete this?",
              style: const TextStyle(fontFamily: 'NanumFontSetup_TTF_SQUARE')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(isKorean ? "아니오" : "No",
                  style: TextStyle(
                      fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      color: AppStyles.maindeepblue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(isKorean ? "예" : "Yes",
                  style: TextStyle(
                      fontFamily: 'NanumFontSetup_TTF_SQUARE',
                      color: AppStyles.maindeepblue)),
            ),
          ],
        );
      },
    );
  }
}
