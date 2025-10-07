import 'package:textcrypt/textcrypt.dart';

/// Example demonstrating the usage of the textcrypt package.
///
/// This example shows how to:
/// 1. Use individual codecs
/// 2. Create and use codec pipelines
/// 3. Handle different data types and configurations
void main() {
  print('=== TextCrypt Package Example ===\n');

  // Example 1: Individual Codecs
  // individualCodecExamples();

  print('\n' + '=' * 50 + '\n');

  // Example 2: Codec Pipelines
  pipelineExamples();

  print('\n' + '=' * 50 + '\n');

  // Example 3: Real-world Usage Scenarios
  // realWorldExamples();
}

/// Demonstrates usage of individual codecs
void individualCodecExamples() {
  print('1. Individual Codec Examples');
  print('-' * 30);

  const originalText = 'Hello, World! 🌍 This is a test message.';
  print('Original text: "$originalText"');
  print('\n');

  // Base64 Codec
  print('Base64 Codec:');
  const base64Codec = Base64Codec();
  final base64Encoded = base64Codec.encode(originalText);
  final base64Decoded = base64Codec.decode(base64Encoded);
  print('  Encoded: $base64Encoded');
  print('  Decoded: "$base64Decoded"');
  print('  Valid: ${base64Codec.isValidInput(base64Encoded)}');
  print('\n');

  // Hex Codec (lowercase)
  print('Hex Codec (lowercase):');
  const hexCodec = HexCodec();
  final hexEncoded = hexCodec.encode(originalText);
  final hexDecoded = hexCodec.decode(hexEncoded);
  print(
    '  Encoded: ${hexEncoded.length > 50 ? hexEncoded.substring(0, 50) + '...' : hexEncoded}',
  );
  print('  Decoded: "$hexDecoded"');
  print('\n');

  // Hex Codec (uppercase)
  print('Hex Codec (uppercase):');
  const hexUpperCodec = HexCodec(uppercase: true);
  final hexUpperEncoded = hexUpperCodec.encode('Hi!');
  final hexUpperDecoded = hexUpperCodec.decode(hexUpperEncoded);
  print('  Encoded: $hexUpperEncoded');
  print('  Decoded: "$hexUpperDecoded"');
  print('\n');

  // GZip Codec
  print('GZip Codec:');
  const gzipCodec = GzipCodec();
  final repetitiveText = 'This pattern repeats. ' * 20;
  print('  Original size: ${repetitiveText.length} characters');
  final gzipEncoded = gzipCodec.encode(repetitiveText);
  final gzipDecoded = gzipCodec.decode(gzipEncoded);
  print('  Compressed (Base64): ${gzipEncoded.length} characters');
  print(
    '  Compression ratio: ${(gzipEncoded.length / repetitiveText.length * 100).toStringAsFixed(1)}%',
  );
  print('  Decoded matches: ${gzipDecoded == repetitiveText}');
  print('\n');

  // GZip with different compression levels
  print('GZip Compression Levels:');
  final testText = 'Compression test with repeated data. ' * 10;
  for (int level in [1, 6, 9]) {
    final gzipLevel = GzipCodec(level: level);
    final compressed = gzipLevel.encode(testText);
    print(
      '  Level $level: ${compressed.length} chars (${(compressed.length / testText.length * 100).toStringAsFixed(1)}%)',
    );
  }
}

/// Demonstrates usage of codec pipelines
void pipelineExamples() {
  print('2. Codec Pipeline Examples');
  print('-' * 30);

  const originalText =
      'This is a message that will go through multiple transformations.';
  print('Original: "$originalText"');
  print('\n\n\n');

  // Simple Pipeline: Base64 → Hex
  print('Pipeline: Base64 → Hex');
  final simplePipeline = CodecPipeline([const Base64Codec(), const HexCodec()]);
  print('Pipeline name: ${simplePipeline.name}');
  final simpleEncoded = simplePipeline.encode(originalText);
  final simpleDecoded = simplePipeline.decode(simpleEncoded);
  // print('Encoded: ${simpleEncoded.substring(0, 60)}...');
  print('Encoded: ${simpleEncoded}');
  print('Decoded: "$simpleDecoded"');
  print('Match: ${simpleDecoded == originalText}');
  print('\n\n\n');

  // Complex Pipeline: GZip → Base64 → Hex
  print('Pipeline: GZip → Base64 → Hex');
  final complexPipeline = CodecPipeline([
    const GzipCodec(level: 9),
    const Base64Codec(),
    const HexCodec(uppercase: true),
  ]);
  print('Pipeline name: ${complexPipeline.name}');

  final longText =
      'This is a longer message that will benefit from compression. ' * 25;
  print('Original text: ${longText} ');
  print('Original size: ${longText.length} characters');

  final complexEncoded = complexPipeline.encode(longText);
  final complexDecoded = complexPipeline.decode(complexEncoded);
  print('Processed size: ${complexEncoded.length} characters');
  print(
    'Final ratio: ${(complexEncoded.length / longText.length * 100).toStringAsFixed(1)}%',
  );
  print('Decoded matches: ${complexDecoded == longText}');
  print('\n\n\n');

  // Pipeline manipulation
  print('Pipeline Manipulation:');
  final basePipeline = CodecPipeline([const Base64Codec()]);
  print('Original: ${basePipeline.name} (length: ${basePipeline.length})');

  final extendedPipeline = basePipeline.addCodec(const HexCodec());
  print(
    'Extended: ${extendedPipeline.name} (length: ${extendedPipeline.length})',
  );

  final modifiedPipeline = extendedPipeline.addCodec(const GzipCodec());
  print(
    'Modified: ${modifiedPipeline.name} (length: ${modifiedPipeline.length})',
  );

  final reducedPipeline = modifiedPipeline.removeCodec(1);
  print('Reduced: ${reducedPipeline.name} (length: ${reducedPipeline.length})');
}

/// Demonstrates real-world usage scenarios
void realWorldExamples() {
  print('3. Real-World Usage Scenarios');
  print('-' * 30);

  // Scenario 1: Data Obfuscation for Logs
  print('Scenario 1: Log Data Obfuscation');
  final logPipeline = CodecPipeline([Base64Codec(), HexCodec()]);

  const sensitiveData = 'user_id:12345, email:user@example.com';
  final obfuscated = logPipeline.encode(sensitiveData);
  print('Sensitive: "$sensitiveData"');
  print('Obfuscated: $obfuscated');
  print('Recovered: "${logPipeline.decode(obfuscated)}"');
  print('\n');

  // Scenario 2: Configuration Data Compression
  print('Scenario 2: Configuration Data Compression');
  final configPipeline = CodecPipeline([GzipCodec(level: 9), Base64Codec()]);

  const configJson = '''
  {
    "database": {
      "host": "localhost",
      "port": 5432,
      "credentials": {
        "username": "admin",
        "password": "secret123"
      }
    },
    "features": {
      "logging": true,
      "caching": true,
      "analytics": false
    }
  }
  ''';

  print('Original config size: ${configJson.length} characters');
  final compressedConfig = configPipeline.encode(configJson);
  print('Compressed size: ${compressedConfig.length} characters');
  print(
    'Compression ratio: ${(compressedConfig.length / configJson.length * 100).toStringAsFixed(1)}%',
  );

  final recoveredConfig = configPipeline.decode(compressedConfig);
  print(
    'Data integrity: ${recoveredConfig == configJson ? 'Perfect' : 'Corrupted'}',
  );
  print('\n');

  // Scenario 3: Multi-layer Security
  print('Scenario 3: Multi-layer Text Processing');
  final securityPipeline = CodecPipeline([
    GzipCodec(level: 6), // Compress first
    Base64Codec(), // Encode to text-safe format
    HexCodec(uppercase: true), // Additional encoding layer
  ]);

  const secretMessage =
      'TOP SECRET: The meeting is scheduled for tomorrow at 3 PM in conference room B.';
  print('Secret message length: ${secretMessage.length} characters');

  final processed = securityPipeline.encode(secretMessage);
  print('Processed length: ${processed.length} characters');
  print('Processed sample: ${processed.substring(0, 80)}...');

  final recovered = securityPipeline.decode(processed);
  print('Recovery successful: ${recovered == secretMessage}');
  print('\n');

  // Scenario 4: Error Handling Demo
  print('Scenario 4: Error Handling');
  try {
    const base64 = Base64Codec();
    base64.decode('Invalid@Base64!');
  } catch (e) {
    print('Caught Base64 error: ${e.runtimeType} - ${e.toString()}');
  }

  try {
    CodecPipeline([]); // Empty pipeline
  } catch (e) {
    print('Caught Pipeline error: ${e.runtimeType} - ${e.toString()}');
  }

  try {
    final pipeline = CodecPipeline([Base64Codec(), HexCodec()]);
    pipeline.decode('InvalidData');
  } catch (e) {
    print('Caught Pipeline decode error: ${e.runtimeType}');
    print('Error message: ${e.toString()}');
  }
  print('\n');

  // Scenario 5: Performance Comparison
  print('Scenario 5: Performance Comparison');
  final testData = 'Performance test data. ' * 100;
  final stopwatch = Stopwatch();

  // Individual Base64
  stopwatch.start();
  const base64 = Base64Codec();
  for (int i = 0; i < 1000; i++) {
    final encoded = base64.encode(testData);
    base64.decode(encoded);
  }
  stopwatch.stop();
  print('Base64 only (1000 iterations): ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();

  // Pipeline: GZip → Base64
  stopwatch.start();
  final pipeline = CodecPipeline([GzipCodec(), Base64Codec()]);
  for (int i = 0; i < 1000; i++) {
    final encoded = pipeline.encode(testData);
    pipeline.decode(encoded);
  }
  stopwatch.stop();
  print(
    'GZip+Base64 pipeline (1000 iterations): ${stopwatch.elapsedMilliseconds}ms',
  );

  print('\nExample completed successfully! ✅');
}
