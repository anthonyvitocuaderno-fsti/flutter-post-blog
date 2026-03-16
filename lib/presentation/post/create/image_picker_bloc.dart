import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_blog/domain/use_case/post/delete_image_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/upload_image_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_picker_event.dart';
import 'image_picker_state.dart';

// BLoC
// TODO if an uploaded image was not saved or finalized, delete it from storage.
class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final UploadImageUseCase uploadImageUseCase;
  final DeleteImageUseCase deleteImageUseCase;

  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _temporaryImageUrls = [];

  ImagePickerBloc(this.uploadImageUseCase, this.deleteImageUseCase) : super(ImagePickerInitial()) {
    on<PickImage>(_onPickImage);
    on<UploadImage>(_onUploadImage);
    on<ImageSaved>(_onImageSaved);
  }

  Future<void> _onPickImage(PickImage event, Emitter<ImagePickerState> emit) async {
    final permission = event.source == ImageSource.gallery ? Permission.photos : Permission.camera;
    final status = await permission.status;
    if (!status.isGranted) {
      final newStatus = await permission.request();
      if (!newStatus.isGranted) {
        if (await permission.isPermanentlyDenied) {
          emit(const PermissionPermanentlyDenied('Permission permanently denied. Please enable it in app settings.'));
        } else {
          emit(const PermissionDenied('Permission denied. Please grant access to pick images.'));
        }
        emit(ImagePickerInitial());
        return;
      }
    }
    emit(ImagePicking());
    try {
      final pickedFile = await _imagePicker.pickImage(source: event.source);
      if (pickedFile != null) {
        emit(ImageSelected(File(pickedFile.path)));
      } else {
        emit(ImagePickerInitial());
      }
    } catch (e) {
      emit(ImagePickerInitial());
    }
  }

  Future<void> _onUploadImage(UploadImage event, Emitter<ImagePickerState> emit) async {
    emit(ImageUploading());
    try {
      final imageUrl = await uploadImageUseCase.call(UploadImageParams(file: event.imageFile));
      _temporaryImageUrls.add(imageUrl);
      emit(ImageUploaded(imageUrl));
    } catch (e) {
      emit(const ImageUploadError('Failed to upload image.'));
    }
  }

  Future<void> _onImageSaved(ImageSaved event, Emitter<ImagePickerState> emit) async {
    // Clear temporary URLs when an image is saved with a post
    if (state is ImageUploaded) {
      _temporaryImageUrls.removeWhere( (url) => url == (state as ImageUploaded).imageUrl);
    } else {
      _temporaryImageUrls.removeLast();
    }

    if (event.oldImageUrl != null) {
      _temporaryImageUrls.add(event.oldImageUrl!); // for cleanup too
    }
    
    emit(ImagePickerInitial());
    // TODO use case to delete remaining temporary images if needed and silently
    // hard limit
    int tempImagesToDelete = _temporaryImageUrls.length;
    while (_temporaryImageUrls.isNotEmpty && tempImagesToDelete > 0) {
      String url = _temporaryImageUrls.removeAt(0);
      try {
        await deleteImageUseCase.call(DeleteImageParams(imageUrl: url));
      } catch (e) {
        // Log error but don't emit failure state since this is a cleanup operation
        print('Failed to delete temporary image: $e');
        _temporaryImageUrls.add(url); // Re-add to list for potential retry later
      }
      tempImagesToDelete--;
    }
  }
}