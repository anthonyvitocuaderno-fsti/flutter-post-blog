import 'package:flutter_post_blog/domain/model/post_model.dart';

/// Arguments passed between routes.
///
/// Add new classes here as the app grows.
class PostDetailRouteArgs {
  final PostModel post;

  PostDetailRouteArgs(this.post);
}
