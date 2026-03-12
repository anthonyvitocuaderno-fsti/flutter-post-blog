class Email {
  final String value;

  Email(this.value);

  bool isValid() => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
}
