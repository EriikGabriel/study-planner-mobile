import 'dart:typed_data';

// Web cannot access local file paths; return null and rely on FilePicker bytes.
Future<Uint8List?> readFileBytes(String path) async {
  return null;
}
