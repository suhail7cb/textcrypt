import 'package:test/test.dart';
import 'package:textcrypt/textcrypt.dart';

void main() {
  group('CodecPipeline', () {
    test('should create pipeline with correct name', () {
      final pipeline = CodecPipeline([
        const Base64Codec(),
        const HexCodec(),
      ]);

      expect(pipeline.name, equals('Pipeline[Base64 → Hex]'));
    });

    test('should reject empty codec list', () {
      expect(() => CodecPipeline([]), throwsA(isA<ArgumentError>()));
    });

    test('should encode through pipeline in correct order', () {
      final pipeline = CodecPipeline([
        const Base64Codec(),
        const HexCodec(),
      ]);

      const input = 'Hello';
      final result = pipeline.encode(input);

      // Manual step-by-step verification
      final step1 = const Base64Codec().encode(input); // 'SGVsbG8='
      final step2 = const HexCodec().encode(step1); // Hex of 'SGVsbG8='

      expect(result, equals(step2));
    });

    test('should decode through pipeline in reverse order', () {
      final pipeline = CodecPipeline([
        const Base64Codec(),
        const HexCodec(),
      ]);

      const input = 'Hello';
      final encoded = pipeline.encode(input);
      final decoded = pipeline.decode(encoded);

      expect(decoded, equals(input));
    });

    test('should handle complex pipeline with compression', () {
      final pipeline = CodecPipeline([
        const GzipCodec(),
        const Base64Codec(),
        const HexCodec(),
      ]);

      const input =
          'This is a longer text that will be compressed, then base64 encoded, then hex encoded.';
      final encoded = pipeline.encode(input);
      final decoded = pipeline.decode(encoded);

      expect(decoded, equals(input));
    });

    test('should handle empty string encoding', () {
      final pipeline = CodecPipeline([const Base64Codec()]);
      expect(() => pipeline.encode(''), throwsA(isA<ArgumentError>()));
    });

    test('should handle empty string decoding', () {
      final pipeline = CodecPipeline([const Base64Codec()]);
      expect(() => pipeline.decode(''), throwsA(isA<ArgumentError>()));
    });

    test('should provide meaningful error messages on failure', () {
      final pipeline = CodecPipeline([
        const Base64Codec(),
        const HexCodec(),
      ]);

      expect(
        () => pipeline.decode('InvalidInput'),
        throwsA(
          allOf(
            isA<FormatException>(),
            predicate<FormatException>((e) => e.message.contains('Hex')),
          ),
        ),
      );
    });

    test('should add codec to pipeline', () {
      final original = CodecPipeline([const Base64Codec()]);
      final extended = original.addCodec(const HexCodec());

      expect(extended.length, equals(2));
      expect(extended.name, equals('Pipeline[Base64 → Hex]'));
      expect(original.length, equals(1)); // Original unchanged
    });

    test('should remove codec from pipeline', () {
      final original = CodecPipeline([
        const Base64Codec(),
        const HexCodec(),
        const GzipCodec(),
      ]);

      final modified = original.removeCodec(1); // Remove HexCodec

      expect(modified.length, equals(2));
      expect(modified.name, equals('Pipeline[Base64 → GZip]'));
      expect(original.length, equals(3)); // Original unchanged
    });

    test('should throw error when removing codec with invalid index', () {
      final pipeline = CodecPipeline([const Base64Codec()]);

      expect(() => pipeline.removeCodec(-1), throwsA(isA<RangeError>()));
      expect(() => pipeline.removeCodec(1), throwsA(isA<RangeError>()));
    });

    test('should throw error when removing last codec', () {
      final pipeline = CodecPipeline([const Base64Codec()]);

      expect(() => pipeline.removeCodec(0), throwsA(isA<StateError>()));
    });

    test('should validate input using last codec', () {
      final pipeline = CodecPipeline([
        const GzipCodec(),
        const Base64Codec(),
      ]);

      expect(pipeline.isValidInput('SGVsbG8='), isTrue); // Valid Base64
      expect(pipeline.isValidInput('Invalid@'), isFalse); // Invalid Base64
      expect(pipeline.isValidInput(''), isFalse); // Empty
    });

    test('should report correct length and emptiness', () {
      final pipeline = CodecPipeline([
        const Base64Codec(),
        const HexCodec(),
      ]);

      expect(pipeline.length, equals(2));
      expect(pipeline.isEmpty, isFalse);
      expect(pipeline.isNotEmpty, isTrue);
    });

    test('should handle single codec pipeline', () {
      final pipeline = CodecPipeline([const Base64Codec()]);

      const input = 'Hello World';
      final encoded = pipeline.encode(input);
      final decoded = pipeline.decode(encoded);

      expect(decoded, equals(input));
      expect(pipeline.length, equals(1));
    });

    test('should handle round-trip with various input types', () {
      final pipeline = CodecPipeline([
        const GzipCodec(),
        const Base64Codec(),
        const HexCodec(uppercase: true),
      ]);

      final testCases = [
        'Simple text',
        'Text with UTF-8: 世界 🌍',
        'Numbers and symbols: 12345 !@#\$%^&*()',
        'Multi-line\ntext\nwith\nbreaks',
        'A' * 1000, // Long repetitive text (good for compression)
      ];

      for (final testCase in testCases) {
        final encoded = pipeline.encode(testCase);
        final decoded = pipeline.decode(encoded);
        expect(decoded, equals(testCase), reason: 'Failed for: $testCase');
      }
    });

    test('should handle pipeline with different codec configurations', () {
      final pipeline = CodecPipeline([
        const GzipCodec(level: 9), // Maximum compression
        const Base64Codec(),
        const HexCodec(uppercase: true),
      ]);

      const input = 'Testing pipeline with configured codecs.';
      final String encoded = pipeline.encode(input);
      final String decoded = pipeline.decode(encoded);

      expect(decoded, equals(input));
    });
  });
}
