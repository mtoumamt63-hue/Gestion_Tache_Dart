import 'dart:convert';
import 'dart:io';

class JsonStorage {
  final String filePath;

  JsonStorage(this.filePath);

  Future<List<Map<String, dynamic>>> read() async {
    final file = File(filePath);

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString(encoding: utf8);

    if (content.trim().isEmpty) {
      return [];
    }

    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  Future<void> write(List<Map<String, dynamic>> data) async {
    final file = File(filePath);

    await file.parent.create(recursive: true);

    await file.writeAsString(jsonEncode(data), encoding: utf8);
  }
}
