import 'dart:convert';
import 'dart:typed_data';

class Base64Service {
  static String encodeText(String input) => base64Encode(utf8.encode(input));

  static String decodeText(String input) => utf8.decode(base64Decode(input));

  static String encodeBytes(Uint8List input) => base64Encode(input);

  static Uint8List decodeBytesFromUtf8(Uint8List input) {
    return base64Decode(utf8.decode(input));
  }

  static bool isValidBase64(String input) {
    final base64RegEx = RegExp(r'^[A-Za-z0-9+/]+={0,2}\$');
    return input.length % 4 == 0 && base64RegEx.hasMatch(input);
  }
}
