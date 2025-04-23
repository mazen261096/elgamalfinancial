import 'package:moneytrack/presentation/resources/const_widgets/internet_connection.dart';
import 'package:moneytrack/presentation/splash/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:upgrader/upgrader.dart';

import '../cubit/auth/Auth_cubit.dart';
import '../cubit/category/category_cubit.dart';
import '../cubit/verification/verification_cubit.dart';
import '../cubit/wallet/wallet_cubit.dart';
import '../presentation/resources/langauge_manager.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/themes_manager.dart';

class MyApp extends StatefulWidget {
  // named constructor
  const MyApp._internal();

  static final MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; // factory

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    LanguageManager().getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit()..autoLogin(),
        ),
        BlocProvider<WalletCubit>(
          create: (_) => WalletCubit(),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit()..fetchCategory(),
        ),
        BlocProvider<VerificationCubit>(
          create: (_) => VerificationCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360.0, 736.0),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: getAppThemeData(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            home: UpgradeAlert(
                child: StreamBuilder(
                    stream: InternetConnectionChecker().onStatusChange,
                    initialData: InternetConnectionStatus.connected,
                    builder: (context, snap) {
                      if (snap.data == InternetConnectionStatus.connected) {
                        return const SplashScreen();
                      } else {
                        return const NotConnectedScreen();
                      }
                    })),
          );
        },
      ),
    );
  }
}

/*    MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        home: UpgradeAlert(
            child: SplashScreen()),
        theme: getAppThemeData(),
      )   */
