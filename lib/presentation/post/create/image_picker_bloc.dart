import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_picker_event.dart';
import 'image_picker_state.dart';

// BLoC
class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePicker _imagePicker = ImagePicker();

  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<PickImage>(_onPickImage);
    on<UploadImage>(_onUploadImage);
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
      // TODO: Call UploadImageUseCase.execute(event.imageFile) to get imageUrl
      // For now, simulate success with a dummy URL
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload
      const imageUrl = 'https://placehold.co/1200x630/jpg'; // Dummy URL
      emit(ImageUploaded(imageUrl));
    } catch (e) {
      emit(const ImageUploadError('Failed to upload image.'));
    }
  }
}