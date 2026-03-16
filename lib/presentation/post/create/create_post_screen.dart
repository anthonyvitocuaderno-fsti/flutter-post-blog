import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/value_objects/post_content.dart';
import 'package:flutter_post_blog/domain/value_objects/post_title.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_bloc.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_event.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_state.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_bloc.dart';
import 'image_picker_event.dart';
import 'image_picker_state.dart';
import 'package:app_settings/app_settings.dart';

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

    final imagePickerState = context.read<ImagePickerBloc>().state;
    final imageUrl = imagePickerState is ImageUploaded ? imagePickerState.imageUrl : widget.existingPost?.imageUrl;

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
              imageUrl: imageUrl,
            ),
          );
    } else {
      context.read<PostFormBloc>().add(
            CreatePostRequested(title: postTitle, content: postContent, imageUrl: imageUrl),
          );
    }
  }

  void _onDelete() {
    final post = widget.existingPost;
    if (post == null) return;
    context.read<PostFormBloc>().add(DeletePostRequested(id: post.id));
  }

  void _showImageSourceDialog(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Image'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
        ],
      ),
    );
    if (source != null) {
      context.read<ImagePickerBloc>().add(PickImage(source));
    }
  }

  void _showPermissionDialog(BuildContext context, String message, {required bool isPermanentlyDenied}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostFormBloc, PostFormState>(listener: (context, state) {
            if (state.status == PostFormStatus.success) {
              context.read<ImagePickerBloc>().add(ImageSaved(oldImageUrl:widget.existingPost?.imageUrl));
              NavigationService.pop(true);
            } else if (state.status == PostFormStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
              );
            }
          }),
          BlocListener<ImagePickerBloc, ImagePickerState>(
          listener: (context, state) {
            if (state is PermissionDenied) {
              _showPermissionDialog(context, state.errorMessage, isPermanentlyDenied: false);
            } else if (state is PermissionPermanentlyDenied) {
              _showPermissionDialog(context, state.errorMessage, isPermanentlyDenied: true);
            } else if (state is ImageSelected) {
              context.read<ImagePickerBloc>().add(UploadImage(state.imageFile));
            } else if (state is ImageUploadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          })
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  BlocBuilder<ImagePickerBloc, ImagePickerState>(
                    builder: (context, state) {
                      return CachedNetworkImage(
                imageUrl: state is ImageUploaded ? state.imageUrl : widget.existingPost?.imageUrl ?? 'https://placehold.co/600x315/jpg', 
                width: 600,
                height: 315,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: 
                      state is ImageUploading ?
                        const Center(child: CircularProgressIndicator())
                      : const Center(child: Icon(Icons.image, size: 50, color: Colors.white))
                      
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red,),
                )
              );
                    }
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                      _showImageSourceDialog(context);
                  },
  child: Text("Upload Image"),
)
                ],
                
              ),
              
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 10,
                textAlignVertical: TextAlignVertical.top,
              ),
              const SizedBox(height: 16),
              BlocBuilder<PostFormBloc, PostFormState>(
                builder: (context, state) {
                  final imagePickerState = context.read<ImagePickerBloc>().state;
                  final isLoading = state.status == PostFormStatus.loading || imagePickerState is ImageUploading;
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
