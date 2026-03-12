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
  @override
  void initState() {
    super.initState();
    context.read<PostListBloc>().add(const PostListStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostListBloc, PostListState>(
      listener: (context, state) {
        final route = state.navigationRoute;
        if (route == null) return;

        if (state.navigationRemoveUntil && state.navigationPredicate != null) {
          NavigationService.navigateToAndRemoveUntil(
            route,
            state.navigationPredicate!,
            arguments: state.navigationArguments,
          );
        } else if (state.navigationReplace) {
          NavigationService.navigateToReplacement(
            route,
            arguments: state.navigationArguments,
          );
        } else {
          NavigationService.navigateTo(
            route,
            arguments: state.navigationArguments,
          );
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
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.content),
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
