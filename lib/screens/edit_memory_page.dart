import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:provider/provider.dart';

class EditMemoryPage extends StatefulWidget {
  final MemoryLog memory;
  const EditMemoryPage({super.key, required this.memory});

  @override
  State<EditMemoryPage> createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memory.title);
    _contentController = TextEditingController(text: widget.memory.contents);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'No Date';
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy년 MM월 dd일').format(dateTime);
    } catch (e) {
      return 'No Date';
    }
  }

  void _saveChanges() {
    setState(() {
      widget.memory.title = _titleController.text;
      widget.memory.contents = _contentController.text;
    });

    Navigator.pop(context, widget.memory); // 수정된 메모리 데이터를 반환
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isKorean ? "기억 고치기" : "Edit memory",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              isKorean ? "저장" : "Save",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _formatDate(widget.memory.timestamp),
              style: const TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
