import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

/// A simple [BlocObserver] implementation that logs bloc events and state changes.
///
/// This is useful to trace how the app transitions between states during
/// navigation, authentication, data loading, etc.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    developer.log(
      'Bloc Event: ${bloc.runtimeType} -> $event',
      name: 'AppBlocObserver',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log(
      'Bloc Transition: ${bloc.runtimeType} ${transition.event} -> ${transition.nextState}',
      name: 'AppBlocObserver',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    developer.log(
      'Bloc Error: ${bloc.runtimeType} -> $error',
      name: 'AppBlocObserver',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
