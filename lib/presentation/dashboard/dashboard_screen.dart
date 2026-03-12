import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/presentation/post/list/post_list_screen.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';

import 'dashboard_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
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
      child: Scaffold(
        appBar: AppBar(
          title: Builder(builder: (context) {
            final user = context.select((DashboardBloc bloc) => bloc.state.user);
            final name = user?.name ?? 'Guest';
            return Text('Hi, $name');
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<DashboardBloc>().add(const DashboardLogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Tab views
            return IndexedStack(
              index: _selectedIndex,
              children: const [
                // Tab 1: Posts list
                SafeArea(child: PostListView()),
                // Tab 2: placeholder
                Center(child: Text('Tab 2 (coming soon)')),
                // Tab 3: placeholder
                Center(child: Text('Tab 3 (coming soon)')),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Posts'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Tab 2'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Tab 3'),
          ],
        ),
      ),
    );
  }
}
