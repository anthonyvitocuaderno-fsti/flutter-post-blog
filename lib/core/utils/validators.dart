class Validators {
  static bool isEmail(String value) => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);

  static bool isNotEmpty(String value) => value.trim().isNotEmpty;
}
