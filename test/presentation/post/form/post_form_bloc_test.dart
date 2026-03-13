import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/use_case/post/create_post_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/delete_post_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/update_post_use_case.dart';
import 'package:flutter_post_blog/domain/value_objects/post_content.dart';
import 'package:flutter_post_blog/domain/value_objects/post_title.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_bloc.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_event.dart';
import 'package:flutter_post_blog/presentation/post/form/post_form_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_form_bloc_test.mocks.dart';

@GenerateMocks([
  CreatePostUseCase,
  UpdatePostUseCase,
  DeletePostUseCase,
])
void main() {
  late PostFormBloc postFormBloc;
  late MockCreatePostUseCase mockCreatePostUseCase;
  late MockUpdatePostUseCase mockUpdatePostUseCase;
  late MockDeletePostUseCase mockDeletePostUseCase;

  setUp(() {
    mockCreatePostUseCase = MockCreatePostUseCase();
    mockUpdatePostUseCase = MockUpdatePostUseCase();
    mockDeletePostUseCase = MockDeletePostUseCase();

    postFormBloc = PostFormBloc(
      createPostUseCase: mockCreatePostUseCase,
      updatePostUseCase: mockUpdatePostUseCase,
      deletePostUseCase: mockDeletePostUseCase,
    );
  });

  tearDown(() {
    postFormBloc.close();
  });

  group('PostFormBloc', () {
    const testTitle = 'Test Title';
    const testContent = 'Test Content';
    final testTitleVO = PostTitle(testTitle);
    final testContentVO = PostContent(testContent);

    final testPost = PostModel(
      id: '1',
      title: testTitle,
      content: testContent,
      authorId: 'user1',
      authorName: 'Author 1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    group('Initial state', () {
      test('should have initial state', () {
        expect(postFormBloc.state, const PostFormState.initial());
      });
    });

    group('CreatePostRequested', () {
      blocTest<PostFormBloc, PostFormState>(
        'should emit loading then success when create post succeeds',
        build: () => postFormBloc,
        setUp: () {
          when(mockCreatePostUseCase(any)).thenAnswer((_) async => 'new_post_id');
        },
        act: (bloc) => bloc.add(CreatePostRequested(
          title: testTitleVO,
          content: testContentVO,
        )),
        expect: () => [
          const PostFormState(status: PostFormStatus.loading),
          const PostFormState(status: PostFormStatus.success),
        ],
        verify: (_) {
          verify(mockCreatePostUseCase(any)).called(1);
        },
      );

      blocTest<PostFormBloc, PostFormState>(
        'should emit loading then failure when create post fails',
        build: () => postFormBloc,
        setUp: () {
          when(mockCreatePostUseCase(any)).thenThrow(Exception('Create failed'));
        },
        act: (bloc) => bloc.add(CreatePostRequested(
          title: testTitleVO,
          content: testContentVO,
        )),
        expect: () => [
          const PostFormState(status: PostFormStatus.loading),
          PostFormState(status: PostFormStatus.failure, errorMessage: 'Exception: Create failed'),
        ],
      );
    });

    group('UpdatePostRequested', () {
      blocTest<PostFormBloc, PostFormState>(
        'should emit loading then success when update post succeeds',
        build: () => postFormBloc,
        setUp: () {
          when(mockUpdatePostUseCase(any)).thenAnswer((_) async {});
        },
        act: (bloc) => bloc.add(UpdatePostRequested(
          post: testPost,
          title: testTitleVO,
          content: testContentVO,
        )),
        expect: () => [
          const PostFormState(status: PostFormStatus.loading),
          const PostFormState(status: PostFormStatus.success),
        ],
        verify: (_) {
          verify(mockUpdatePostUseCase(any)).called(1);
        },
      );

      blocTest<PostFormBloc, PostFormState>(
        'should emit loading then failure when update post fails',
        build: () => postFormBloc,
        setUp: () {
          when(mockUpdatePostUseCase(any)).thenThrow(Exception('Update failed'));
        },
        act: (bloc) => bloc.add(UpdatePostRequested(
          post: testPost,
          title: testTitleVO,
          content: testContentVO,
        )),
        expect: () => [
          const PostFormState(status: PostFormStatus.loading),
          PostFormState(status: PostFormStatus.failure, errorMessage: 'Exception: Update failed'),
        ],
      );
    });

    group('DeletePostRequested', () {
      blocTest<PostFormBloc, PostFormState>(
        'should emit loading then success when delete post succeeds',
        build: () => postFormBloc,
        setUp: () {
          when(mockDeletePostUseCase(any)).thenAnswer((_) async {});
        },
        act: (bloc) => bloc.add(DeletePostRequested(id: testPost.id)),
        expect: () => [
          const PostFormState(status: PostFormStatus.loading),
          const PostFormState(status: PostFormStatus.success),
        ],
        verify: (_) {
          verify(mockDeletePostUseCase(any)).called(1);
        },
      );

      blocTest<PostFormBloc, PostFormState>(
        'should emit loading then failure when delete post fails',
        build: () => postFormBloc,
        setUp: () {
          when(mockDeletePostUseCase(any)).thenThrow(Exception('Delete failed'));
        },
        act: (bloc) => bloc.add(DeletePostRequested(id: testPost.id)),
        expect: () => [
          const PostFormState(status: PostFormStatus.loading),
          PostFormState(status: PostFormStatus.failure, errorMessage: 'Exception: Delete failed'),
        ],
      );
    });

    group('State reset scenarios', () {
      test('should reset to initial state after successful create', () async {
        // Start with initial state
        expect(postFormBloc.state, const PostFormState.initial());

        // Mock successful create
        when(mockCreatePostUseCase(any)).thenAnswer((_) async => 'new_post_id' 'new_post_id');

        // Add create event
        postFormBloc.add(CreatePostRequested(
          title: testTitleVO,
          content: testContentVO,
        ));

        // Wait for state changes
        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            const PostFormState(status: PostFormStatus.loading),
            const PostFormState(status: PostFormStatus.success),
          ]),
        );

        // Create a new bloc instance (simulating navigation back to form)
        final newBloc = PostFormBloc(
          createPostUseCase: mockCreatePostUseCase,
          updatePostUseCase: mockUpdatePostUseCase,
          deletePostUseCase: mockDeletePostUseCase,
        );

        // New bloc should start with initial state
        expect(newBloc.state, const PostFormState.initial());

        newBloc.close();
      });

      test('should reset to initial state after successful update', () async {
        // Start with initial state
        expect(postFormBloc.state, const PostFormState.initial());

        // Mock successful update
        when(mockUpdatePostUseCase(any)).thenAnswer((_) async {});

        // Add update event
        postFormBloc.add(UpdatePostRequested(
          post: testPost,
          title: testTitleVO,
          content: testContentVO,
        ));

        // Wait for state changes
        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            const PostFormState(status: PostFormStatus.loading),
            const PostFormState(status: PostFormStatus.success),
          ]),
        );

        // Create a new bloc instance (simulating navigation back to form)
        final newBloc = PostFormBloc(
          createPostUseCase: mockCreatePostUseCase,
          updatePostUseCase: mockUpdatePostUseCase,
          deletePostUseCase: mockDeletePostUseCase,
        );

        // New bloc should start with initial state
        expect(newBloc.state, const PostFormState.initial());

        newBloc.close();
      });

      test('should reset to initial state after successful delete', () async {
        // Start with initial state
        expect(postFormBloc.state, const PostFormState.initial());

        // Mock successful delete
        when(mockDeletePostUseCase(any)).thenAnswer((_) async {});

        // Add delete event
        postFormBloc.add(DeletePostRequested(id: testPost.id));

        // Wait for state changes
        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            const PostFormState(status: PostFormStatus.loading),
            const PostFormState(status: PostFormStatus.success),
          ]),
        );

        // Create a new bloc instance (simulating navigation back to form)
        final newBloc = PostFormBloc(
          createPostUseCase: mockCreatePostUseCase,
          updatePostUseCase: mockUpdatePostUseCase,
          deletePostUseCase: mockDeletePostUseCase,
        );

        // New bloc should start with initial state
        expect(newBloc.state, const PostFormState.initial());

        newBloc.close();
      });

      test('should maintain initial state when navigating to edit form', () async {
        // Start with initial state
        expect(postFormBloc.state, const PostFormState.initial());

        // Add edit event (simulating navigation to edit existing post)
        postFormBloc.add(EditPostRequested(post: testPost));

        // Wait for state changes - should emit navigation params then reset
        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            predicate<PostFormState>((state) =>
                state.status == PostFormStatus.initial &&
                state.navigationParams != null),
            const PostFormState(status: PostFormStatus.initial),
          ]),
        );

        // Bloc should be back to initial state
        expect(postFormBloc.state, const PostFormState.initial());
      });

      test('should not have side effects between operations', () async {
        // First operation: successful create
        when(mockCreatePostUseCase(any)).thenAnswer((_) async => 'new_post_id');
        postFormBloc.add(CreatePostRequested(
          title: testTitleVO,
          content: testContentVO,
        ));

        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            const PostFormState(status: PostFormStatus.loading),
            const PostFormState(status: PostFormStatus.success),
          ]),
        );

        // Second operation: failed update (should not be affected by previous success)
        when(mockUpdatePostUseCase(any)).thenThrow(Exception('Update error'));
        postFormBloc.add(UpdatePostRequested(
          post: testPost,
          title: testTitleVO,
          content: testContentVO,
        ));

        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            const PostFormState(status: PostFormStatus.loading),
            PostFormState(status: PostFormStatus.failure, errorMessage: 'Exception: Update error'),
          ]),
        );

        // Third operation: successful delete (should not be affected by previous failure)
        when(mockDeletePostUseCase(any)).thenAnswer((_) async {});
        postFormBloc.add(DeletePostRequested(id: testPost.id));

        await expectLater(
          postFormBloc.stream,
          emitsInOrder([
            const PostFormState(status: PostFormStatus.loading),
            const PostFormState(status: PostFormStatus.success),
          ]),
        );
      });
    });
  });
}