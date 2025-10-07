import 'package:test/test.dart';
import 'package:textcrypt/textcrypt.dart';

void main() {
  group('GzipCodec', () {
    late GzipCodec codec;

    setUp(() {
      codec = const GzipCodec();
    });

    test('should have correct name', () {
      expect(codec.name, equals('GZip'));
    });

    test('should compress and decompress simple text', () {
      const String input = 'Hello, World!';
      final String compressed = codec.encode(input);
      final String decompressed = codec.decode(compressed);

      expect(decompressed, equals(input));
      expect(compressed, isNot(equals(input)));
    });

    test('should handle different compression levels', () {
      const String input =
          'This is a longer text that should compress well when using GZip compression algorithm.';

      final GzipCodec codec1 = GzipCodec(level: 1);
      final GzipCodec codec9 = GzipCodec(level: 9);

      final String compressed1 = codec1.encode(input);
      final String compressed9 = codec9.encode(input);

      final String decompressed1 = codec1.decode(compressed1);
      final String decompressed9 = codec9.decode(compressed9);

      expect(decompressed1, equals(input));
      expect(decompressed9, equals(input));
    });

    test('should throw error for invalid compression level', () {
      expect(() => GzipCodec(level: -1).encode('test'),
          throwsA(isA<ArgumentError>()));
      expect(() => GzipCodec(level: 10).encode('test'),
          throwsA(isA<ArgumentError>()));
    });

    test('should handle UTF-8 characters', () {
      const String input = 'Hello, 世界! 🌍 Testing compression with Unicode.';
      final String compressed = codec.encode(input);
      final String decompressed = codec.decode(compressed);
      expect(decompressed, equals(input));
    });

    test('should handle empty string encoding', () {
      expect(() => codec.encode(''), throwsA(isA<ArgumentError>()));
    });

    test('should handle empty string decoding', () {
      expect(() => codec.decode(''), throwsA(isA<ArgumentError>()));
    });

    test('should handle invalid compressed input', () {
      expect(() => codec.decode('NotCompressedData'),
          throwsA(isA<FormatException>()));
    });

    test('should validate compressed input correctly', () {
      const String input =
          'This text will be compressed for validation testing.';
      final String compressed = codec.encode(input);

      expect(codec.isValidInput(compressed), isTrue);
      expect(codec.isValidInput('InvalidData'), isFalse);
      expect(codec.isValidInput(''), isFalse);
    });

    test('should achieve compression for repetitive text', () {
      final String repetitiveText = 'Hello World! ' * 100; // 1300 characters
      final String compressed = codec.encode(repetitiveText);
      final String decompressed = codec.decode(compressed);

      expect(decompressed, equals(repetitiveText));
      // Base64 encoded compressed data should be shorter than original for repetitive text
      expect(compressed.length, lessThan(repetitiveText.length));
    });

    test('should handle round-trip compression/decompression', () {
      const List<String> testCases = [
        'Simple text',
        'Text with numbers 12345 and symbols !@#\$%',
        'Multi-line\ntext\nwith\nline\nbreaks',
        '中文测试内容',
        'Mixed content: English, 中文, العربية, 🚀🌟',
        '', // This should throw, but we'll test it in the error cases
      ];

      for (final testCase in testCases) {
        if (testCase.isEmpty) continue; // Skip empty string

        final String compressed = codec.encode(testCase);
        final String decompressed = codec.decode(compressed);
        expect(decompressed, equals(testCase), reason: 'Failed for: $testCase');
      }
    });

    test('should maintain data integrity with large text', () {
      final String largeText =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 1000;
      final String compressed = codec.encode(largeText);
      final String decompressed = codec.decode(compressed);

      expect(decompressed, equals(largeText));
    });

    test('should work with different compression levels maintaining integrity',
        () {
      const String input =
          'Testing different compression levels for data integrity.';

      for (int level = 0; level <= 9; level++) {
        final GzipCodec testCodec = GzipCodec(level: level);
        final String compressed = testCodec.encode(input);
        final String decompressed = testCodec.decode(compressed);

        expect(decompressed, equals(input),
            reason: 'Failed at compression level $level');
      }
    });
  });
}
