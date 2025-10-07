import 'core/codec.dart';

/// A pipeline for chaining multiple text codecs together.
///
/// This class allows you to combine multiple codecs into a single processing
/// pipeline. Encoding applies codecs in order, while decoding applies them
/// in reverse order.
///
/// Example:
/// ```dart
/// final pipeline = CodecPipeline([
///   GzipCodec(),
///   Base64Codec(),
///   HexCodec(),
/// ]);
///
/// final encoded = pipeline.encode('Hello, World!');
/// final decoded = pipeline.decode(encoded);
/// ```
class CodecPipeline implements TextCodec {
  /// Creates a new codec pipeline with the given codecs.
  ///
  /// [codecs] List of codecs to chain together. Must not be empty.
  /// The order matters: encoding applies codecs in order, decoding in reverse.
  CodecPipeline(this.codecs) {
    if (codecs.isEmpty) {
      throw ArgumentError('Codec pipeline must contain at least one codec');
    }
  }

  /// The list of codecs in this pipeline.
  final List<TextCodec> codecs;

  @override
  String get name => 'Pipeline[${codecs.map((c) => c.name).join(' → ')}]';

  @override
  String encode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    String result = input;
    for (int i = 0; i < codecs.length; i++) {
      try {
        result = codecs[i].encode(result);
      } catch (e) {
        throw FormatException(
            'Failed at codec ${codecs[i].name} (step ${i + 1}): $e');
      }
    }
    return result;
  }

  @override
  String decode(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    String result = input;
    // Apply codecs in reverse order for decoding
    for (int i = codecs.length - 1; i >= 0; i--) {
      try {
        result = codecs[i].decode(result);
      } catch (e) {
        throw FormatException(
            'Failed at codec ${codecs[i].name} (step ${codecs.length - i}): $e');
      }
    }
    return result;
  }

  @override
  bool isValidInput(String input) {
    if (input.isEmpty) return false;

    // For a pipeline, we can only validate against the last codec
    // since that's what the input should match for decoding
    return codecs.isNotEmpty && codecs.last.isValidInput(input);
  }

  /// Adds a codec to the end of the pipeline.
  ///
  /// [codec] The codec to add.
  /// Returns a new pipeline with the codec added.
  CodecPipeline addCodec(TextCodec codec) {
    return CodecPipeline([...codecs, codec]);
  }

  /// Removes a codec from the pipeline at the specified index.
  ///
  /// [index] The index of the codec to remove.
  /// Returns a new pipeline with the codec removed.
  ///
  /// Throws [RangeError] if index is out of bounds.
  /// Throws [StateError] if trying to remove the last codec in pipeline.
  CodecPipeline removeCodec(int index) {
    if (index < 0 || index >= codecs.length) {
      throw RangeError(
          'Index $index is out of bounds for pipeline of length ${codecs.length}');
    }

    if (codecs.length == 1) {
      throw StateError('Cannot remove the last codec from pipeline');
    }

    final newCodecs = [...codecs];
    newCodecs.removeAt(index);
    return CodecPipeline(newCodecs);
  }

  /// Returns the number of codecs in this pipeline.
  int get length => codecs.length;

  /// Returns whether the pipeline is empty.
  bool get isEmpty => codecs.isEmpty;

  /// Returns whether the pipeline is not empty.
  bool get isNotEmpty => codecs.isNotEmpty;
}
