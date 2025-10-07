# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-07

### Added
- Initial release of TextCrypt package
- **Core Architecture**:
  - `TextCodec` abstract interface for all codecs
  - `CodecPipeline` class for chaining multiple codecs
- **Built-in Codecs**:
  - `Base64Codec` - Standard Base64 encoding/decoding
  - `GzipCodec` - GZip compression with configurable compression levels (0-9)
  - `HexCodec` - Hexadecimal encoding with uppercase/lowercase options
- **Features**:
  - Pure Dart implementation (Flutter-independent)
  - UTF-8 and ASCII support across all codecs
  - Comprehensive input validation for each codec
  - Meaningful error messages with specific codec failure information
  - Pipeline manipulation (add/remove codecs)
- **Testing**:
  - 100% test coverage for all codecs
  - Edge case testing (empty strings, invalid inputs, Unicode characters)
  - Performance testing and validation
  - Pipeline integration tests
- **Documentation**:
  - Complete API documentation with DartDoc comments
  - Comprehensive README with examples
  - Usage examples for individual codecs and pipelines
  - Real-world scenario demonstrations

### Security
- Input validation to prevent malformed data processing
- Safe error handling to prevent information leakage
- No external dependencies to minimize attack surface

---

## Future Planned Features

### [0.2.0] - Planned
- Additional codecs (URL encoding, HTML entities)
- Performance optimizations for large data sets
- Streaming codec support for large files

### [0.2.1] - Planned  
- Plugin system for dynamic codec registration
- Custom codec factory and discovery mechanism
- Advanced pipeline features (conditional encoding, branching)

### [0.3.0] - Planned
- Breaking changes for improved API consistency
- Advanced compression algorithms (Brotli, LZ4)
- Async codec support for non-blocking operations