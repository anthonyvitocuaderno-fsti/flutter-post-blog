class Password {
  final String value;

  Password(this.value);

  bool isValid() => value.length >= 6;
}
