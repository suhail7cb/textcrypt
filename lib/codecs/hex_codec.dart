import 'dart:convert';
import '../core/codec.dart';

/// Hexadecimal codec for encoding and decoding text using hexadecimal representation.
///
/// This codec converts text to its hexadecimal representation and vice versa.
/// It handles UTF-8 encoding/decoding automatically.
///
/// Example:
/// ```dart
/// final codec = HexCodec();
/// final encoded = codec.encode('Hello'); // 48656c6c6f
/// final decoded = codec.decode(encoded); // Hello
/// ```
class HexCodec implements TextCodec {
  /// Creates a new Hex codec instance.
  ///
  /// [uppercase] Whether to use uppercase letters (A-F) or lowercase (a-f).
  /// Default is false (lowercase).
  const HexCodec({this.uppercase = false});

  /// Whether to use uppercase hex digits.
  final bool uppercase;

  @override
  String get name => 'Hex';

  @override
  String encode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    try {
      final bytes = utf8.encode(input);
      final hexString =
          bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

      return uppercase ? hexString.toUpperCase() : hexString;
    } catch (e) {
      throw FormatException('Failed to encode input to hex: $e');
    }
  }

  @override
  String decode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    if (!isValidInput(input)) {
      throw FormatException('Invalid hexadecimal input format');
    }

    try {
      if (input.length % 2 != 0) {
        throw FormatException('Hex string length must be even');
      }

      final bytes = <int>[];
      for (int i = 0; i < input.length; i += 2) {
        final hexByte = input.substring(i, i + 2);
        final byte = int.parse(hexByte, radix: 16);
        bytes.add(byte);
      }

      return utf8.decode(bytes);
    } catch (e) {
      throw FormatException('Failed to decode hex input: $e');
    }
  }

  @override
  bool isValidInput(String input) {
    if (input.isEmpty) return false;

    // Check if string contains only valid hex characters and has even length
    final hexPattern = RegExp(r'^[0-9A-Fa-f]*$');
    return hexPattern.hasMatch(input) && input.length % 2 == 0;
  }
}
