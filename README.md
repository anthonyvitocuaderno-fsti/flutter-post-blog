# Flutter Post Blog

A Flutter application tested on Android for creating and managing blog posts, built using Clean BLoC architecture and Firebase services. All users can view a public list of posts, while authenticated users can create, update, and delete their own posts.

## Features

- **User Authentication**: Sign up with name, email, and password; sign in with email and password
- **Post Management** (Authenticated Users): Create, edit, and delete own posts with optional images
- **Public Post List**: Browse all posts in guest mode with real-time updates for the top 20 posts
- **Image Upload**: Select images from gallery or camera (currently mocked with placeholder URLs)
- **Permissions**: Camera and gallery access with app settings integration

## Architecture

The app follows Clean BLoC architecture, separating concerns into three main layers:

### Presentation Layer
- **Screens**: Splash screen, login/register screens, dashboard with posts tab (and placeholder tabs for future features)
- **BLoC State Management**: Handles UI state and user interactions (e.g., `AuthBloc`, `PostListBloc`, `PostFormBloc`, `ImagePickerBloc`)
- **TODO**: Refactor and reorganize dashboard
- **TODO**: Exceptions/errors mapping, error and crash screens, crashlytics

### Domain Layer
- **Core Functionality**: User authentication, post CRUD operations, image upload/delete
- **Use Cases**: Business logic encapsulation (e.g., `SignInUseCase`, `CreatePostUseCase`, `UploadImageUseCase`)
- **Models/Entities**: Data structures for posts, users, and validation objects
- **Repositories**: Abstract interfaces for data access

### Data Layer
- **Remote Data Sources**: Firebase-integrated datasources for posts and auth (Firestore for data, Firebase Auth for authentication)
- **Local Data Sources**: Not currently used
- **Services**: Firebase Storage service for image handling (currently mocked)

## Technologies and Libraries

### Core
- **Flutter**: UI framework
- **Dart**: Programming language

### Architecture & State Management
- **Bloc**: State management library for BLoC pattern
- **Get_it**: Dependency injection container

### Firebase Integrations
- **Firebase Core**: Core Firebase functionality
- **Firebase Auth**: User authentication
- **Cloud Firestore**: NoSQL database for posts
- **Firebase Storage**: File storage for images (currently mocked)

### Third-Party Libraries
- **Image Picker**: Select images from gallery or camera
- **Cached Network Image**: Efficient image loading and caching
- **Permission Handler**: Manage app permissions
- **App Settings**: Open app settings for permission management
- **Intl**: Internationalization support (not really used except for date strings)
- **Connectivity Plus**: Network connectivity checks (not really used)

### Development
- **Flutter Lints**: Code linting
- **Mockito**: Mocking for unit tests

## Setup and Installation

1. **Prerequisites**:
   - Flutter SDK (version 3.22.0 or higher)
   - Dart SDK (version 3.10.7 or higher)
   - Firebase project with Auth, Firestore, and Storage enabled

2. **Clone the repository**:
   ```
   git clone <repository-url>
   cd flutter_post_blog
   ```

3. **Install dependencies**:
   ```
   flutter pub get
   ```

4. **Configure Firebase**:
   - Add your `google-services.json` (Android) (or `GoogleService-Info.plist` (iOS) - not tested) to the respective directories
   - https://github.com/anthonyvitocuaderno-fsti/flutter-post-blog/blob/main/android/app/google-services.json
   - Update Firebase configuration in `lib/firebase_options.dart` if needed
   - Update Firestore.rules(https://github.com/anthonyvitocuaderno-fsti/flutter-post-blog/blob/main/firestore.rules) and deploy if needed.

5. **Run the app**:
   ```
   flutter run
   ```

## Usage

1. **Guest Mode**: Browse posts without signing in
2. **Authentication**: Sign up or sign in with email and password to access post management
3. **View Posts**: Browse the public list of posts on the home screen
4. **Create Post**: Tap the add button to create a new post with title, content, and optional image (authenticated users only)
5. **Edit/Delete Post**: Access menu on your own posts to edit or delete (authenticated users only)
6. **Image Upload**: When creating/editing, tap "Upload Image" to select from gallery or camera (images currently return placeholder URLs)

## Testing

**TODO**: Image picker bloc unit tests, data source and repository unit tests, navigation unit tests, value_objects and validations unit test.

Run unit tests:
```
flutter test
```

