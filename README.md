# TextCrypt

A modular Dart package for text obfuscation and compression using various encoding/decoding techniques. This package provides a clean, extensible architecture for chaining multiple text transformation codecs together.

[![Pub Version](https://img.shields.io/pub/v/textcrypt.svg)](https://pub.dev/packages/textcrypt)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/textcrypt)](https://pub.dev/packages/textcrypt)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **🔧 Modular Architecture**: Each codec implements a common `TextCodec` interface
- **⛓️ Chainable Codecs**: Combine multiple codecs in pipelines (e.g., GZip → Base64 → Hex)
- **🛡️ Built-in Codecs**: Base64, GZip compression, and Hexadecimal encoding
- **✅ Pure Dart**: No external dependencies, works everywhere Dart runs
- **🧪 Well Tested**: Comprehensive test coverage with edge cases
- **📚 Fully Documented**: Complete API documentation with examples

## Built-in Codecs

| Codec | Description | Use Cases |
|-------|-------------|-----------|
| **Base64Codec** | Standard Base64 encoding/decoding | Data transmission, text-safe encoding |
| **GzipCodec** | GZip compression with configurable levels | Data compression, reducing payload size |
| **HexCodec** | Hexadecimal encoding with case options | Binary data representation, debugging |

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  textcrypt: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Quick Start

### Individual Codecs

```dart
import 'package:textcrypt/textcrypt.dart';

void main() {
  // Base64 encoding
  const base64 = Base64Codec();
  final encoded = base64.encode('Hello, World!');
  final decoded = base64.decode(encoded);
  print('Encoded: $encoded'); // SGVsbG8sIFdvcmxkIQ==
  print('Decoded: $decoded'); // Hello, World!

  // Hex encoding with uppercase
  const hex = HexCodec(uppercase: true);
  final hexEncoded = hex.encode('Hi!');
  print('Hex: $hexEncoded'); // 486921

  // GZip compression
  const gzip = GzipCodec(level: 9);
  final compressed = gzip.encode('Repeated text ' * 100);
  print('Compression ratio: ${compressed.length / (1500)}'); // Much smaller!
}
```

### Codec Pipelines

```dart
import 'package:textcrypt/textcrypt.dart';

void main() {
  // Create a pipeline: Compress → Base64 → Hex
  final pipeline = CodecPipeline([
    const GzipCodec(level: 9),
    const Base64Codec(),
    const HexCodec(uppercase: true),
  ]);

  const originalText = 'This will be compressed, base64 encoded, then hex encoded!';
  
  // Encode through the entire pipeline
  final result = pipeline.encode(originalText);
  print('Pipeline result: $result');

  // Decode back to original (automatically reverses the pipeline)
  final recovered = pipeline.decode(result);
  print('Recovered: $recovered');
  print('Match: ${recovered == originalText}'); // true
}
```

## API Reference

### TextCodec Interface

All codecs implement the `TextCodec` interface:

```dart
abstract class TextCodec {
  String encode(String input);
  String decode(String input);
  bool isValidInput(String input);
  String get name;
}
```

### Base64Codec

```dart
const codec = Base64Codec();
final encoded = codec.encode('Hello'); // SGVsbG8=
final decoded = codec.decode('SGVsbG8='); // Hello
```

### GzipCodec

```dart
const codec = GzipCodec(level: 6); // Compression level 0-9
final compressed = codec.encode('Long repetitive text...');
final decompressed = codec.decode(compressed);
```

### HexCodec

```dart
const codec = HexCodec(uppercase: true); // Optional uppercase
final hex = codec.encode('Hi!'); // 486921
final text = codec.decode('486921'); // Hi!
```

### CodecPipeline

```dart
final pipeline = CodecPipeline([codec1, codec2, codec3]);

// Pipeline operations
final extended = pipeline.addCodec(newCodec);
final reduced = pipeline.removeCodec(index);
print('Pipeline: ${pipeline.name}'); // Pipeline[Codec1 → Codec2 → Codec3]
```

## Advanced Usage

### Custom Codec Implementation

```dart
class ROT13Codec implements TextCodec {
  @override
  String get name => 'ROT13';

  @override
  String encode(String input) {
    return input.split('').map((char) {
      final code = char.codeUnitAt(0);
      if (code >= 65 && code <= 90) {
        return String.fromCharCode((code - 65 + 13) % 26 + 65);
      } else if (code >= 97 && code <= 122) {
        return String.fromCharCode((code - 97 + 13) % 26 + 97);
      }
      return char;
    }).join();
  }

  @override
  String decode(String input) => encode(input); // ROT13 is symmetric

  @override
  bool isValidInput(String input) => input.isNotEmpty;
}

// Use in pipeline
final pipeline = CodecPipeline([
  ROT13Codec(),
  const Base64Codec(),
]);
```

### Error Handling

```dart
try {
  const codec = Base64Codec();
  final result = codec.decode('Invalid@Input');
} on FormatException catch (e) {
  print('Decoding failed: $e');
} on ArgumentError catch (e) {
  print('Invalid argument: $e');
}
```

### Real-world Examples

#### Data Obfuscation for Logs
```dart
final logObfuscator = CodecPipeline([
  const Base64Codec(),
  const HexCodec(),
]);

final sensitiveData = 'user_id:12345, email:user@example.com';
final obfuscated = logObfuscator.encode(sensitiveData);
// Store obfuscated data, decode when needed
```

#### Configuration Compression
```dart
final configCompressor = CodecPipeline([
  const GzipCodec(level: 9),
  const Base64Codec(),
]);

final largeConfig = '{"key": "value", ...}'; // Large JSON config
final compressed = configCompressor.encode(largeConfig);
// Significantly smaller for storage/transmission
```

## Testing

Run the test suite:

```bash
dart test
```

The package includes comprehensive tests for:
- Individual codec functionality
- Pipeline operations
- Error handling
- Edge cases and validation
- Performance characteristics

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Run `dart pub get`
3. Make your changes
4. Run `dart test` to ensure tests pass
5. Run `dart analyze` to check for issues
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.

---

Made with ❤️ for the Dart community