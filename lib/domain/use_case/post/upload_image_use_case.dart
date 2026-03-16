import'dart:io';
import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class UploadImageUseCase extends BaseUseCase<String, UploadImageParams> {
  final PostRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<String> call(UploadImageParams params) {

    return repository.uploadImage(params.file);
  }
}

class UploadImageParams {
  final File file;

  UploadImageParams({required this.file});
}
