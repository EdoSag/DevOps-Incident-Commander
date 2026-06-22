import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

@NowaGenerated()
class SecurityService {
  SecurityService._();

  static const String _defaultSalt = 'DevOpsIncidentCommander_SecureSalt_2025!';

  static List<int> _deriveKey(String password, String salt) {
    final keySource = '${password}:${salt}';
    return sha256.convert(utf8.encode(keySource)).bytes;
  }

  static String encrypt(String plainText, {String? customKey}) {
    if (plainText.isEmpty) {
      return '';
    }
    final keyBytes = _deriveKey(customKey ?? _defaultSalt, _defaultSalt);
    final textBytes = utf8.encode(plainText);
    final cipherBytes = List<int>.filled(textBytes.length, 0);
    for (int i = 0; i < textBytes.length; i++) {
      final keyByte = keyBytes[i % keyBytes.length];
      cipherBytes[i] = textBytes[i] ^ keyByte ^ (i * 17 % 256);
    }
    return base64.encode(cipherBytes);
  }

  static String decrypt(String cipherText, {String? customKey}) {
    if (cipherText.isEmpty) {
      return '';
    }
    try {
      final keyBytes = _deriveKey(customKey ?? _defaultSalt, _defaultSalt);
      final cipherBytes = base64.decode(cipherText);
      final plainBytes = List<int>.filled(cipherBytes.length, 0);
      for (int i = 0; i < cipherBytes.length; i++) {
        final keyByte = keyBytes[i % keyBytes.length];
        plainBytes[i] = cipherBytes[i] ^ keyByte ^ (i * 17 % 256);
      }
      return utf8.decode(plainBytes);
    } catch (e) {
      return 'DECRYPTION_ERROR';
    }
  }
}
