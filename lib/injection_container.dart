// import 'package:firebase_auth_demo/data/datasources/auth_remote_datasource.dart';
import 'package:firebase_auth_demo/core/constants/app_constants.dart';
import 'package:firebase_auth_demo/data/datasources/auth_remote_datasource.dart';
import 'package:firebase_auth_demo/data/datasources/foods_remote_datasource.dart';
import 'package:firebase_auth_demo/data/datasources/locals/secure_storage_data_source.dart';
import 'package:firebase_auth_demo/data/datasources/system_remote_datasource.dart';
import 'package:firebase_auth_demo/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth_demo/data/repositories/food_repository.impl.dart';
import 'package:firebase_auth_demo/data/repositories/system_repository_impl.dart';
import 'package:firebase_auth_demo/domain/repositories/auth_repository.dart';
import 'package:firebase_auth_demo/domain/repositories/food_repository.dart';
import 'package:firebase_auth_demo/domain/repositories/system_repository.dart';
import 'package:firebase_auth_demo/domain/usecases/auth/login_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/auth/logout_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/auth/signup_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/food_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/system_usecase.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'data/datasources/auth_remote_datasource.dart';
// import 'data/repositories/auth_repository_impl.dart';
// import 'domain/repositories/auth_repository.dart';
// import 'domain/usecases/auth/login_usecase.dart';
// import 'domain/usecases/auth/logout_usecase.dart';
// import 'presentation/blocs/auth/auth_cubit.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:food_pick/core/constants/app_constants.dart';
// import 'package:food_pick/data/datasources/foods_remote_datasource.dart';
// import 'package:food_pick/data/datasources/locals/secure_storage_data_source.dart';
// import 'package:food_pick/data/repositories/food_repository.impl.dart';
// import 'package:food_pick/domain/repositories/food_repository.dart';
// import 'package:food_pick/domain/usecases/auth/signup_usecase.dart';
// import 'package:food_pick/domain/usecases/food_usecase.dart';
// import 'package:food_pick/presentation/blocs/auth/food_cubit.dart';

final sl = GetIt.instance;

// Future<void> init() async {
//   // External
//   sl.registerLazySingleton(() => GoogleSignIn());
//   sl.registerLazySingleton(() => http.Client());

//   // Data sources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(client: sl()),
//   );
//   sl.registerLazySingleton<DailyFoodsRemoteDataSource>(
//     () => DailyFoodsRemoteDataSourceImpl(
//       client: sl(),
//       baseUrl: AppConstants.apiBaseUrl,
//     ),
//   );

//   // Repositories
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(remoteDataSource: sl()),
//   );
//   sl.registerLazySingleton<FoodRepository>(
//     () => FoodRepositoryImpl(remoteDataSource: sl()),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => LoginUseCase(sl()));
//   sl.registerLazySingleton(() => LogoutUseCase(sl()));
//   sl.registerLazySingleton(() => GetDailyFoodsUseCase(sl()));

//   // Cubits
//   sl.registerFactory(() => AuthCubit(loginUseCase: sl(), logoutUseCase: sl()));
// }

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());

  // // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<FoodsRemoteDataSource>(
    () => DailyFoodsRemoteDataSourceImpl(
      client: sl(),
      baseUrl: AppConstants.apiBaseUrl,
    ),
  );
  sl.registerLazySingleton<SystemRemoteDataSource>(
    () => SystemRemoteDataSourceImpl(
      client: sl(),
      baseUrl: AppConstants.apiBaseUrl,
    ),
  );
  sl.registerLazySingleton(
      () => SecureStorageDataSource(FlutterSecureStorage()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        remoteDataSource: sl(), secureStorageDataSource: sl()),
  );
  sl.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(
        remoteDataSource: sl(), secureStorageDataSource: sl()),
  );
  sl.registerLazySingleton<SystemRepository>(
    () => SystemRepositoryImpl(
        remoteDataSource: sl(), secureStorageDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetFoodDataUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => SystemRequestUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      signupUseCase: sl(),
      systemRequestUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => DailyFoodsCubit(getFoodsDataUseCase: sl()),
  );
}
