import 'dart:convert';
import '../core/codec.dart';

/// Base64 codec for encoding and decoding text using Base64 algorithm.
///
/// This codec provides Base64 encoding and decoding functionality using
/// Dart's built-in base64 implementation. It handles UTF-8 encoding/decoding
/// automatically.
///
/// Example:
/// ```dart
/// final codec = Base64Codec();
/// final encoded = codec.encode('Hello, World!'); // SGVsbG8sIFdvcmxkIQ==
/// final decoded = codec.decode(encoded); // Hello, World!
/// ```
class Base64Codec implements TextCodec {
  /// Creates a new Base64 codec instance.
  const Base64Codec();

  @override
  String get name => 'Base64';

  @override
  String encode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    try {
      final bytes = utf8.encode(input);
      return base64.encode(bytes);
    } catch (e) {
      throw FormatException('Failed to encode input: $e');
    }
  }

  @override
  String decode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    if (!isValidInput(input)) {
      throw FormatException('Invalid Base64 input format');
    }

    try {
      final bytes = base64.decode(input);
      return utf8.decode(bytes);
    } catch (e) {
      throw FormatException('Failed to decode Base64 input: $e');
    }
  }

  @override
  bool isValidInput(String input) {
    if (input.isEmpty) return false;

    // Basic Base64 validation
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    return base64Pattern.hasMatch(input) && input.length % 4 == 0;
  }
}
