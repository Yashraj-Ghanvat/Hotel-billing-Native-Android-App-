import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  /// Generates a random salt string
  static String generateSalt([int length = 16]) {
    final rand = Random.secure();
    final values = List<int>.generate(length, (i) => rand.nextInt(256));
    return base64Url.encode(values);
  }

  /// Hashes a PIN with a given salt using SHA-256
  static String hashPin(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies if a raw PIN matches the stored hash & salt
  static bool verifyPin(String pin, String storedHash, String salt) {
    final hash = hashPin(pin, salt);
    return hash == storedHash;
  }
}
