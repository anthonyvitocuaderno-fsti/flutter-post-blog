import 'package:get_it/get_it.dart';

import 'datasource_module.dart';
import 'repository_module.dart';
import 'usecase_module.dart';

/// Sets up all dependency injection modules
void setupDI() {
  setupDataSources();
  setupRepositories();
  setupUseCases();
}

/// Gets an instance of a registered type from GetIt
T getIt<T extends Object>() => GetIt.instance.get<T>();

/// Registers a singleton instance
void registerSingleton<T extends Object>(T instance) {
  GetIt.instance.registerSingleton(instance);
}

/// Registers a lazy singleton
void registerLazySingleton<T extends Object>(T Function() factoryFunc) {
  GetIt.instance.registerLazySingleton(factoryFunc);
}

/// Registers a factory
void registerFactory<T extends Object>(T Function() factoryFunc) {
  GetIt.instance.registerFactory(factoryFunc);
}