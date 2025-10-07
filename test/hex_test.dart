import 'package:test/test.dart';
import 'package:textcrypt/textcrypt.dart';

void main() {
  group('HexCodec', () {
    late HexCodec codec;

    setUp(() {
      codec = const HexCodec();
    });

    test('should have correct name', () {
      expect(codec.name, equals('Hex'));
    });

    test('should encode simple text to lowercase hex', () {
      final result = codec.encode('Hello');
      expect(result, equals('48656c6c6f'));
    });

    test('should encode simple text to uppercase hex', () {
      const uppercaseCodec = HexCodec(uppercase: true);
      final result = uppercaseCodec.encode('Hello');
      expect(result, equals('48656C6C6F'));
    });

    test('should decode hex string correctly', () {
      final result = codec.decode('48656c6c6f');
      expect(result, equals('Hello'));
    });

    test('should decode uppercase hex string correctly', () {
      final result = codec.decode('48656C6C6F');
      expect(result, equals('Hello'));
    });

    test('should handle UTF-8 characters', () {
      const input = 'Hi 🚀';
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

    test('should handle invalid hex characters', () {
      expect(() => codec.decode('48656g6c6f'), throwsA(isA<FormatException>()));
    });

    test('should handle odd-length hex string', () {
      expect(() => codec.decode('48656c6c6'), throwsA(isA<FormatException>()));
    });

    test('should validate hex input correctly', () {
      expect(codec.isValidInput('48656c6c6f'), isTrue);
      expect(codec.isValidInput('48656C6C6F'), isTrue);
      expect(
          codec.isValidInput('48656g6c6f'), isFalse); // Invalid character 'g'
      expect(codec.isValidInput('48656c6c6'), isFalse); // Odd length
      expect(codec.isValidInput(''), isFalse);
    });

    test('should handle round-trip encoding/decoding', () {
      const testCases = [
        'A',
        'Hello World',
        'Text with numbers 12345',
        'Special chars: !@#\$%^&*()',
        '中文测试',
        'Emoji: 🌟💻🚀',
        'Mixed: English 中文 العربية',
      ];

      for (final testCase in testCases) {
        final encoded = codec.encode(testCase);
        final decoded = codec.decode(encoded);
        expect(decoded, equals(testCase), reason: 'Failed for: $testCase');
      }
    });

    test('should produce consistent results with different case settings', () {
      const input = 'Test String';
      const lowercaseCodec = HexCodec(uppercase: false);
      const uppercaseCodec = HexCodec(uppercase: true);

      final lowercaseResult = lowercaseCodec.encode(input);
      final uppercaseResult = uppercaseCodec.encode(input);

      // Both should decode to the same original string
      expect(lowercaseCodec.decode(lowercaseResult), equals(input));
      expect(uppercaseCodec.decode(uppercaseResult), equals(input));
      expect(lowercaseCodec.decode(uppercaseResult),
          equals(input)); // Cross-compatibility
      expect(uppercaseCodec.decode(lowercaseResult),
          equals(input)); // Cross-compatibility
    });

    test('should handle long text', () {
      final longText = 'A' * 1000;
      final encoded = codec.encode(longText);
      final decoded = codec.decode(encoded);
      expect(decoded, equals(longText));
      expect(
          encoded.length, equals(2000)); // Each character becomes 2 hex digits
    });

    test('should handle all ASCII characters', () {
      final buffer = StringBuffer();
      // Test printable ASCII characters (32-126)
      for (int i = 32; i <= 126; i++) {
        buffer.write(String.fromCharCode(i));
      }
      final input = buffer.toString();

      final encoded = codec.encode(input);
      final decoded = codec.decode(encoded);
      expect(decoded, equals(input));
    });

    test('should handle binary data representation', () {
      // Test with bytes that represent binary data
      const input = '\x00\x01\x02\xFF\xFE';
      final encoded = codec.encode(input);
      final decoded = codec.decode(encoded);
      expect(decoded, equals(input));
    });
  });
}
