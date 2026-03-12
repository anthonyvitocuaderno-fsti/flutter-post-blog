import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/exceptions/api_exception.dart';
import '../../../core/utils/logger.dart';
import '../../entity/remote/user_entity_remote.dart';
import '../../../service/firebase_auth_service.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuthService authService;

  AuthRemoteDataSourceImpl({
    required this.firestore,
    required this.authService,
  });

  @override
  Future<String> signIn(String email, String password) async {
    Logger.log('AuthRemoteDataSource: signIn(email: $email)');

    try {
      final userCredential = await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw ApiException('Failed to sign in.');
      }

      final userDoc = await firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        await firestore.collection('users').doc(uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Logger.log('AuthRemoteDataSource: signIn succeeded (uid: $uid)');
      return uid;
    } on FirebaseAuthException catch (e, st) {
      Logger.log('AuthRemoteDataSource: signIn failed (FirebaseAuthException): ${e.message}');
      Logger.log(st.toString());
      throw ApiException(e.message ?? 'Authentication failed');
    } catch (e, st) {
      Logger.log('AuthRemoteDataSource: signIn failed: $e');
      Logger.log(st.toString());
      throw ApiException(e.toString());
    }
  }

  @override
  Future<UserEntityRemote?> getCurrentUser() async {
    Logger.log('AuthRemoteDataSource: getCurrentUser');

    final user = authService.currentUser;
    if (user == null) return null;

    final doc = await firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      return UserEntityRemote(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    }

    return UserEntityRemote.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  @override
  Future<void> signOut() async {
    Logger.log('AuthRemoteDataSource: signOut');
    await authService.signOut();
  }

  @override
  Stream<UserEntityRemote?> authStateChanges() {
    Logger.log('AuthRemoteDataSource: authStateChanges stream created');

    return authService.authStateChanges().asyncMap((user) async {
      Logger.log('AuthRemoteDataSource: authStateChanges event: ${user?.uid ?? 'null'}');

      if (user == null) return null;

      final docSnapshot = await firestore.collection('users').doc(user.uid).get();
      if (!docSnapshot.exists) {
        return UserEntityRemote(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      }

      return UserEntityRemote.fromJson({
        'id': docSnapshot.id,
        ...docSnapshot.data()!,
      });
    });
  }

  @override
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    Logger.log('AuthRemoteDataSource: register(name: $name, email: $email)');

    try {
      final userCredential = await authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw ApiException('Failed to register user.');
      }

      final usersRef = firestore.collection('users');
      final docRef = usersRef.doc(uid);
      await docRef.set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Logger.log('AuthRemoteDataSource: register succeeded (uid: $uid)');
      return uid;
    } on FirebaseAuthException catch (e, st) {
      Logger.log('AuthRemoteDataSource: register failed (FirebaseAuthException): ${e.message}');
      Logger.log(st.toString());
      throw ApiException(e.message ?? 'Authentication failed');
    } catch (e, st) {
      Logger.log('AuthRemoteDataSource: register failed: $e');
      Logger.log(st.toString());
      throw ApiException(e.toString());
    }
  }

  @override
  Future<UserEntityRemote?> getUserByEmail(String email) async {
    Logger.log('AuthRemoteDataSource: getUserByEmail(email: $email)');

    final usersRef = firestore.collection('users');
    final querySnapshot = await usersRef.where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;
    return UserEntityRemote.fromJson({
      'id': doc.id,
      ...doc.data(),
    });
  }
}
