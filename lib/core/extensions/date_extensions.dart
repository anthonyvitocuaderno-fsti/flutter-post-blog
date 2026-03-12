extension DateExtensions on DateTime {
  String toShortDateString() => '${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}';
}
