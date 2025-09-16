import 'package:blank_street/network/api_service.dart';
import 'package:blank_street/screens/cart/bloc/cart_bloc.dart';
import 'package:blank_street/screens/cart/repo/cart_repo.dart';
import 'package:blank_street/screens/orders/bloc/orders_bloc.dart';
import 'package:blank_street/screens/orders/repo/orders_repo.dart';
import 'package:blank_street/screens/shops/repos/shops_repo.dart';
import 'package:blank_street/screens/signup/bloc/signup_bloc.dart';
import 'package:blank_street/screens/signup/repo/signup_repo.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;
Future<void> initInjections() async {
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<OrdersRepo>(() => OrdersRepoImpl());
  sl.registerLazySingleton<OrdersBloc>(() => OrdersBloc(sl()));
  sl.registerLazySingleton<CartRepo>(() => CartRepoImpl());
  sl.registerLazySingleton<CartBloc>(() => CartBloc(sl()));
  sl.registerLazySingleton<SignupRepo>(() => SignupRepoImpl());
  sl.registerLazySingleton<SignupBloc>(() => SignupBloc(sl()));
  sl.registerLazySingleton<ShopsRepo>(() => ShopsRempoImpl(apiService: sl()));
}
