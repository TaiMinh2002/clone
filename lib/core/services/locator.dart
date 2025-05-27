import 'package:get_it/get_it.dart';
import 'auth_service.dart';
import 'post_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<PostService>(() => PostService());
}
