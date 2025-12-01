// Conditional import: use dart:io implementation on mobile/desktop, and web stub otherwise.
// This file re-exports the implementation of `readFileBytes` defined in either
// `file_reader_io.dart` (mobile/desktop) or `file_reader_web.dart` (web).

// The conditional import chooses the web implementation when `dart.library.html`
// is available (web builds), otherwise the IO implementation is used.
export 'file_reader_io.dart' if (dart.library.html) 'file_reader_web.dart';

// Both implementations expose:
// Future<Uint8List?> readFileBytes(String path)
