import 'dart:io';
import 'dart:typed_data';

Future<Uint8List?> readFileBytes(String path) async {
  try {
    final f = File(path);
    return await f.readAsBytes();
  } catch (e) {
    return null;
  }
}
