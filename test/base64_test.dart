import 'package:test/test.dart';
import 'package:textcrypt/textcrypt.dart';

void main() {
  group('Base64Codec', () {
    late Base64Codec codec;

    setUp(() {
      codec = const Base64Codec();
    });

    test('should have correct name', () {
      expect(codec.name, equals('Base64'));
    });

    test('should encode simple text correctly', () {
      final result = codec.encode('Hello');
      expect(result, equals('SGVsbG8='));
    });

    test('should decode simple text correctly', () {
      final result = codec.decode('SGVsbG8=');
      expect(result, equals('Hello'));
    });

    test('should handle UTF-8 characters', () {
      const input = 'Hello, 世界! 🌍';
      final encoded = codec.encode(input);
      final decoded = codec.decode(encoded);
      expect(decoded, equals(input));
    });

    test('should handle empty string encoding', () {
      expect(() => codec.encode(''), throwsA(isA<ArgumentError>()));
    });

    test('should handle empty string decoding', () {
      expect(() => codec.decode(''), throwsA(isA<ArgumentError>()));
    });

    test('should handle invalid Base64 input', () {
      expect(() => codec.decode('Invalid@Base64!'),
          throwsA(isA<FormatException>()));
    });

    test('should validate Base64 input correctly', () {
      expect(codec.isValidInput('SGVsbG8='), isTrue);
      expect(codec.isValidInput('SGVsbG8'), isFalse); // Missing padding
      expect(codec.isValidInput('Invalid@'), isFalse);
      expect(codec.isValidInput(''), isFalse);
    });

    test('should handle round-trip encoding/decoding', () {
      const testCases = [
        'Simple text',
        'Text with numbers 12345',
        'Special chars: !@#\$%^&*()',
        'Multi-line\ntext\nwith\nbreaks',
        '中文测试',
        'Emoji test 🚀🌟💻',
      ];

      for (final testCase in testCases) {
        final encoded = codec.encode(testCase);
        final decoded = codec.decode(encoded);
        expect(decoded, equals(testCase), reason: 'Failed for: $testCase');
      }
    });

    test('should handle long text', () {
      final longText = 'A' * 10000;
      final encoded = codec.encode(longText);
      final decoded = codec.decode(encoded);
      expect(decoded, equals(longText));
    });
  });
}
