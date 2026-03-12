import 'package:equatable/equatable.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class SplashStarted extends SplashEvent {
  const SplashStarted();
}
