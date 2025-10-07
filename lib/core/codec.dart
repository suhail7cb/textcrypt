/// Core interface for all text codecs in the textcrypt package.
///
/// This abstract class defines the contract that all codecs must implement.
/// Each codec provides encoding and decoding functionality for text transformation.
///
/// Example:
/// ```dart
/// class MyCodec implements TextCodec {
///   @override
///   String encode(String input) {
///     // Custom encoding logic
///     return transformedInput;
///   }
///
///   @override
///   String decode(String input) {
///     // Custom decoding logic
///     return originalInput;
///   }
/// }
/// ```
abstract class TextCodec {
  /// Encodes the input string using the codec's specific algorithm.
  ///
  /// [input] The plain text string to be encoded.
  /// Returns the encoded string.
  ///
  /// Throws [ArgumentError] if the input is invalid for this codec.
  /// Throws [FormatException] if encoding fails due to format issues.
  String encode(String input);

  /// Decodes the input string using the codec's specific algorithm.
  ///
  /// [input] The encoded string to be decoded.
  /// Returns the decoded plain text string.
  ///
  /// Throws [ArgumentError] if the input is invalid for this codec.
  /// Throws [FormatException] if decoding fails due to format issues.
  String decode(String input);

  /// Optional method to validate if input can be processed by this codec.
  ///
  /// [input] The string to validate.
  /// Returns true if the input is valid for this codec, false otherwise.
  bool isValidInput(String input) => input.isNotEmpty;

  /// Returns the name/identifier of this codec.
  ///
  /// Used for debugging and pipeline identification.
  String get name;
}
