import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServices() {
  getIt.registerSingleton<AuthenticationService>(AuthenticationService(FirebaseAuth.instance));
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<GoogleSignInProvider>(GoogleSignInProvider());
}