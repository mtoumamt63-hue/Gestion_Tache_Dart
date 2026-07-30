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

    final content = await file.readAsString();

    if (content.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(content);

    if (decoded is! List) {
      throw const FormatException('Le fichier JSON doit contenir une liste.');
    }

    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> write(List<Map<String, dynamic>> data) async {
    final file = File(filePath);

    await file.parent.create(recursive: true);

    final json = const JsonEncoder.withIndent('  ').convert(data);

    await file.writeAsString(json);
  }
}
