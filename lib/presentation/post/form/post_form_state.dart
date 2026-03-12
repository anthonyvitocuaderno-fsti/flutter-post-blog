import 'package:equatable/equatable.dart';

import '../../shared/navigation/navigation_params.dart';

enum PostFormStatus { initial, loading, success, failure }

class PostFormState extends Equatable {
  final PostFormStatus status;
  final String? errorMessage;
  final NavigationParams? navigationParams;

  const PostFormState({
    required this.status,
    this.errorMessage,
    this.navigationParams,
  });

  const PostFormState.initial() : this(status: PostFormStatus.initial);

  PostFormState copyWith({
    PostFormStatus? status,
    String? errorMessage,
    NavigationParams? navigationParams,
  }) {
    return PostFormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationParams: navigationParams,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, navigationParams];
}
