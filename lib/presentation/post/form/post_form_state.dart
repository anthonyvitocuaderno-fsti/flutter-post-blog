import 'package:equatable/equatable.dart';

enum PostFormStatus { initial, loading, success, failure }

class PostFormState extends Equatable {
  final PostFormStatus status;
  final String? errorMessage;

  const PostFormState({required this.status, this.errorMessage});

  const PostFormState.initial() : this(status: PostFormStatus.initial);

  PostFormState copyWith({PostFormStatus? status, String? errorMessage}) {
    return PostFormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
