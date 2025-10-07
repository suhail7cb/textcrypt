/// A modular Dart package for text obfuscation and compression.
///
/// This library provides a set of codecs for encoding and decoding text
/// using various algorithms including Base64, GZip compression, and
/// hexadecimal encoding. Codecs can be used individually or chained
/// together in pipelines for complex transformations.
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:textcrypt/textcrypt.dart';
///
/// // Using individual codecs
/// final base64 = Base64Codec();
/// final encoded = base64.encode('Hello, World!');
/// final decoded = base64.decode(encoded);
///
/// // Using a pipeline
/// final pipeline = CodecPipeline([
///   GzipCodec(),
///   Base64Codec(),
/// ]);
/// final result = pipeline.encode('Some text to compress and encode');
/// ```
library textcrypt;

// Core exports
export 'core/codec.dart';
export 'pipeline.dart';

// Codec exports

export 'codecs/base64_codec.dart';
export 'codecs/gzip_codec.dart';
export 'codecs/hex_codec.dart';
