import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';

import 'post_list_bloc.dart';
import 'post_list_event.dart';
import 'post_list_state.dart';

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

  void _onScroll() {
    final bloc = context.read<PostListBloc>();
    final state = bloc.state;

    if (!state.hasMore || state.isLoadingMore) return;
    if (!_scrollController.hasClients) return;

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
    return BlocListener<PostListBloc, PostListState>(
      listener: (context, state) async {
        final route = state.navigationRoute;
        if (route == null) return;

        final postListBloc = context.read<PostListBloc>();
        final Future<dynamic>? result;
        if (state.navigationRemoveUntil && state.navigationPredicate != null) {
          result = NavigationService.navigateToAndRemoveUntil(
            route,
            state.navigationPredicate!,
            arguments: state.navigationArguments,
          );
        } else if (state.navigationReplace) {
          result = NavigationService.navigateToReplacement(
            route,
            arguments: state.navigationArguments,
          );
        } else {
          result = NavigationService.navigateTo(
            route,
            arguments: state.navigationArguments,
          );
        }

        final value = await result;
        if (!mounted) return;
        if (value == true) {
          postListBloc.add(const PostListStarted());
        }
      },
      child: BlocBuilder<PostListBloc, PostListState>(
        builder: (context, state) {
          if (state.status == PostListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PostListStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
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
                subtitle: Text('By ${post.authorName.isNotEmpty ? post.authorName : 'Unknown'}\n${post.content}'),
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
