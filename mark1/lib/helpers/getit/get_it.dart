import 'package:get_it/get_it.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:mymy_m1/services/authentication/user_session.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => UserSession(getIt<AuthService>()));
}
