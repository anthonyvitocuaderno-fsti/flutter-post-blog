import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/core/services/firestore_service.dart';
import 'package:flutter_post_blog/core/utils/date_util.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';

import 'post_list_bloc.dart';
import 'post_list_event.dart';
import 'post_list_state.dart';

// TODO stateless widget??
class PostListView extends StatefulWidget {
  const PostListView({super.key});

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<PostListBloc>().add(const PostListStarted());
  }

  // TODO key scroll clever logic away from screen, maybe to a helper class
  void _onScroll() {
    final bloc = context.read<PostListBloc>();
    final state = bloc.state;

    if (!state.hasMore || state.isLoadingMore) return;
    if (!_scrollController.hasClients) return;

    // TODO constants
    final threshold = 200; // pixels from bottom to trigger load more
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= threshold) {
      bloc.add(const PostListLoadMoreRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirestoreService.instance
          .collection('posts')
          .orderBy('updatedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Still show the bloc state but report the error as a snack bar.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Realtime update error: ${snapshot.error}'),
                ),
              );
            }
          });
        }

        if (snapshot.hasData) {
          final posts = snapshot.data!.docs
              .map(_postFromDocument)
              .whereType<PostModel>()
              .toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<PostListBloc>().add(PostListUpdated(posts));
            }
          });
        }

        return BlocListener<PostListBloc, PostListState>(
          listener: (context, state) async {
            final postListBloc = context.read<PostListBloc>();
            final result = await NavigationService.navigateIfNeeded(
              state.navigationParams,
              source: 'PostListView',
            );
            if (!mounted) return;
            if (result == true) {
              postListBloc.add(const PostListStarted());
            }
          },
          child: BlocBuilder<PostListBloc, PostListState>(
            builder: (context, state) {
              if (state.status == PostListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == PostListStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? 'Something went wrong'),
                );
              }

              if (state.posts.isEmpty) {
                return const Center(child: Text('No posts available'));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.posts.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.posts.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = state.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(
                      'By ${post.authorName.isNotEmpty ? post.authorName : 'Unknown'} ${DateUtil.formatDateTime(post.updatedAt.toLocal())}\n${post.content}',
                      maxLines:
                          3, // Also restrict the subtitle to a single line
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () {
                      context.read<PostListBloc>().add(PostSelected(post));
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  PostModel? _postFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];

    DateTime parseTimestamp(Object? value) {
      if (value is DateTime) return value;
      if (value is Timestamp) return value.toDate();
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    if (data['title'] == null || data['content'] == null) {
      return null;
    }

    return PostModel(
      id: doc.id,
      title: data['title'] as String,
      content: data['content'] as String,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      createdAt: parseTimestamp(createdAt),
      updatedAt: parseTimestamp(updatedAt),
      imageUrl: data['imageUrl'] as String?,
    );
  }
}

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: const PostListView(),
    );
  }
}
