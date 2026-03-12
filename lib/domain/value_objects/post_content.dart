import 'package:flutter_post_blog/core/utils/validators.dart';

/// A value object representing post content.
///
/// A valid content must not be empty.
class PostContent {
  final String value;

  PostContent(this.value);

  bool isValid() => Validators.isNotEmpty(value);
}
