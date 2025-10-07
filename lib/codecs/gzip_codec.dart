import 'dart:convert';
import 'dart:io';
import '../core/codec.dart';

/// GZip codec for compressing and decompressing text using GZip algorithm.
///
/// This codec provides GZip compression and decompression functionality using
/// Dart's built-in gzip implementation. The compressed data is returned as
/// a Base64-encoded string for easy text handling.
///
/// Example:
/// ```dart
/// final codec = GzipCodec();
/// final compressed = codec.encode('This is a long text that will be compressed...');
/// final decompressed = codec.decode(compressed);
/// ```
class GzipCodec implements TextCodec {
  /// Creates a new GZip codec instance.
  ///
  /// [level] Compression level from 0 (no compression) to 9 (maximum compression).
  /// Default is 6 for balanced compression/speed.
  const GzipCodec({this.level = 6});

  /// The compression level used for GZip compression.
  final int level;

  @override
  String get name => 'GZip';

  @override
  String encode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    if (level < 0 || level > 9) {
      throw ArgumentError('Compression level must be between 0 and 9');
    }

    try {
      final bytes = utf8.encode(input);
      // Use GZipCodec from dart:io with specified compression level
      final gzipCodec = GZipCodec(level: level);
      final compressed = gzipCodec.encode(bytes);
      return base64.encode(compressed);
    } catch (e) {
      throw FormatException('Failed to compress input: $e');
    }
  }

  @override
  String decode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    if (!isValidInput(input)) {
      throw FormatException('Invalid Base64 input format for compressed data');
    }

    try {
      final compressedBytes = base64.decode(input);
      // Use GZipCodec from dart:io to decompress
      final gzipCodec = GZipCodec();
      final decompressed = gzipCodec.decode(compressedBytes);
      return utf8.decode(decompressed);
    } catch (e) {
      throw FormatException('Failed to decompress input: $e');
    }
  }

  @override
  bool isValidInput(String input) {
    if (input.isEmpty) return false;

    try {
      // Try to decode as Base64 first
      final bytes = base64.decode(input);
      // Check if it starts with GZip magic number (1f 8b)
      return bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
    } catch (e) {
      return false;
    }
  }
}
