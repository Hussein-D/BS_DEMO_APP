import 'package:blank_street/core/dependency_injector/dependency_injector.dart';
import 'package:blank_street/screens/cart/bloc/cart_bloc.dart';
import 'package:blank_street/screens/cart/repo/cart_repo.dart';
import 'package:blank_street/screens/orders/bloc/orders_bloc.dart';
import 'package:blank_street/screens/orders/repo/orders_repo.dart';
import 'package:blank_street/screens/shops/bloc/shops_bloc.dart';
import 'package:blank_street/screens/shops/repos/shops_repo.dart';
import 'package:blank_street/screens/signup/bloc/signup_bloc.dart';
import 'package:blank_street/screens/signup/repo/signup_repo.dart';
import 'package:blank_street/screens/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupBloc(sl<SignupRepo>())..add(AutloLogin()),
        ),
        BlocProvider(
          create: (context) =>
              ShopsBloc(repo: sl<ShopsRepo>())..add(GetShops()),
        ),
        BlocProvider(
          create: (context) => CartBloc(sl<CartRepo>())..add(LoadCart()),
        ),
        BlocProvider(
          create: (context) =>
              OrdersBloc(sl<OrdersRepo>())..add(GetOrders(userId: "demo-user")),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blank Street',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: SplashScreen(),
    );
  }
}
