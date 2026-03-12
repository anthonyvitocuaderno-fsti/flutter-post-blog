import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/use_case/post/create_post_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/delete_post_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/update_post_use_case.dart';
import 'post_form_event.dart';
import 'post_form_state.dart';

class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  final CreatePostUseCase createPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;

  PostFormBloc({
    required this.createPostUseCase,
    required this.updatePostUseCase,
    required this.deletePostUseCase,
  }) : super(const PostFormState.initial()) {
    on<CreatePostRequested>(_onCreatePostRequested);
    on<UpdatePostRequested>(_onUpdatePostRequested);
    on<DeletePostRequested>(_onDeletePostRequested);
  }

  Future<void> _onCreatePostRequested(
    CreatePostRequested event,
    Emitter<PostFormState> emit,
  ) async {
    emit(const PostFormState(status: PostFormStatus.loading));

    try {
      await createPostUseCase(
        CreatePostUseCaseParams(
          title: event.title,
          content: event.content,
        ),
      );
      emit(const PostFormState(status: PostFormStatus.success));
    } catch (e) {
      emit(PostFormState(status: PostFormStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdatePostRequested(
    UpdatePostRequested event,
    Emitter<PostFormState> emit,
  ) async {
    emit(const PostFormState(status: PostFormStatus.loading));

    try {
      await updatePostUseCase(
        UpdatePostUseCaseParams(
          post: event.post,
          title: event.title,
          content: event.content,
        ),
      );
      emit(const PostFormState(status: PostFormStatus.success));
    } catch (e) {
      emit(PostFormState(status: PostFormStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeletePostRequested(
    DeletePostRequested event,
    Emitter<PostFormState> emit,
  ) async {
    emit(const PostFormState(status: PostFormStatus.loading));

    try {
      await deletePostUseCase(DeletePostUseCaseParams(event.id));
      emit(const PostFormState(status: PostFormStatus.success));
    } catch (e) {
      emit(PostFormState(status: PostFormStatus.failure, errorMessage: e.toString()));
    }
  }
}
