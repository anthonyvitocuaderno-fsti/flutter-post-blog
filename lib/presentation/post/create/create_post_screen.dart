import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/value_objects/post_content.dart';
import 'package:flutter_post_blog/domain/value_objects/post_title.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_bloc.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_event.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_state.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, this.existingPost});

  final PostModel? existingPost;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool get _isEditing => widget.existingPost != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingPost?.title);
    _contentController = TextEditingController(text: widget.existingPost?.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    final postTitle = PostTitle(title);
    final postContent = PostContent(content);

    if (!postTitle.isValid() || !postContent.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content are required.')),
      );
      return;
    }

    if (_isEditing) {
      final post = widget.existingPost!;
      context.read<PostFormBloc>().add(
            UpdatePostRequested(
              post: post,
              title: postTitle,
              content: postContent,
            ),
          );
    } else {
      context.read<PostFormBloc>().add(
            CreatePostRequested(title: postTitle, content: postContent),
          );
    }
  }

  void _onDelete() {
    final post = widget.existingPost;
    if (post == null) return;
    context.read<PostFormBloc>().add(DeletePostRequested(id: post.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Post' : 'New Post'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _onDelete,
              tooltip: 'Delete post',
            ),
        ],
      ),
      body: BlocListener<PostFormBloc, PostFormState>(
        listener: (context, state) {
          if (state.status == PostFormStatus.success) {
            NavigationService.pop(true);
          } else if (state.status == PostFormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<PostFormBloc, PostFormState>(
                builder: (context, state) {
                  final isLoading = state.status == PostFormStatus.loading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _onSubmit,
                    child: Text(_isEditing ? 'Save changes' : 'Create post'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
