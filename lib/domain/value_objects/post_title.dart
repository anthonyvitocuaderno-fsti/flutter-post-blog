import 'package:flutter_post_blog/core/utils/validators.dart';

/// A value object representing a post title.
///
/// A valid title must not be empty.
class PostTitle {
  final String value;

  PostTitle(this.value);

  bool isValid() => Validators.isNotEmpty(value);
}
