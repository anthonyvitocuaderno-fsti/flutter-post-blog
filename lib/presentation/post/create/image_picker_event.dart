import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object?> get props => [];
}

class PickImage extends ImagePickerEvent {
  final ImageSource source;

  const PickImage(this.source);

  @override
  List<Object?> get props => [source];
}

class UploadImage extends ImagePickerEvent {
  final File imageFile;

  const UploadImage(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}