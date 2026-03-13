import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/core/utils/date_util.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/presentation/dashboard/dashboard_bloc.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_bloc.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_event.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_state.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool get _isOwner {
    final currentUserId = context.select(
      (DashboardBloc bloc) => bloc.state.user?.id,
    );
    return currentUserId != null && currentUserId == widget.post.authorId;
  }

  void _onEditPressed() {
    context.read<PostFormBloc>().add(EditPostRequested(post: widget.post));
  }

  Future<void> _onDeletePressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete post'),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      context.read<PostFormBloc>().add(DeletePostRequested(id: widget.post.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostFormBloc, PostFormState>(
      listener: (context, state) async {
        if (state.status == PostFormStatus.success) {
          NavigationService.pop(true);
        }

        if (state.status == PostFormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unable to delete post.'),
            ),
          );
        }

        await NavigationService.navigateIfNeeded(
          state.navigationParams,
          source: 'PostDetailScreen',
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.post.title),
          actions: _isOwner
              ? [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: _onEditPressed,
                    tooltip: 'Edit post',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _onDeletePressed,
                    tooltip: 'Delete post',
                  ),
                ]
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'By ${widget.post.authorName.isNotEmpty ? widget.post.authorName : 'Unknown'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Updated ${DateUtil.formatDateTime(widget.post.updatedAt.toLocal())}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(child: Text(widget.post.content)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
