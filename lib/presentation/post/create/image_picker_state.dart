import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object?> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class PermissionDenied extends ImagePickerState {
  final String errorMessage;

  const PermissionDenied(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PermissionPermanentlyDenied extends ImagePickerState {
  final String errorMessage;

  const PermissionPermanentlyDenied(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ImagePicking extends ImagePickerState {}

class ImageSelected extends ImagePickerState {
  final File imageFile;

  const ImageSelected(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class ImageUploading extends ImagePickerState {}

class ImageUploaded extends ImagePickerState {
  final String imageUrl;

  const ImageUploaded(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class ImageUploadError extends ImagePickerState {
  final String errorMessage;

  const ImageUploadError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}