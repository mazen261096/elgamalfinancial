import 'package:moneytrack/presentation/add_wallet/add_wallet_screen.dart';
import 'package:moneytrack/presentation/admin_panel/admin_panel_screen.dart';
import 'package:moneytrack/presentation/admins/admins_screen.dart';
import 'package:moneytrack/presentation/freezed_wallets/freezed_wallets_screen.dart';
import 'package:moneytrack/presentation/history/history_item_details.dart';
import 'package:moneytrack/presentation/pay/pay_screen.dart';
import 'package:moneytrack/presentation/resources/strings_manager.dart';
import 'package:moneytrack/presentation/verification/verification_screen.dart';
import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import '../category/category_screen.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import '../members/members_screen.dart';
import '../new_password/new_password_screen.dart';
import '../profile/profile_screen.dart';
import '../register/register_screen.dart';
import '../splash/splash_screen.dart';
import '../success/success_screen.dart';
import '../viewers/viewers_screen.dart';
import '../wallet/wallet_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String homeRoute = "/home";
  static const String verifyNumberRoute = "/verifyNumber";
  static const String newPasswordRoute = "/newPassword";
  static const String addWalletRoute = "/addWallet";
  static const String addWalletSuccessRoute = "/addWalletSuccess";
  static const String walletMemberRoute = "/walletMember";
  static const String membersRoute = "/members";
  static const String viewersRoute = "/viewrs";
  static const String adminPanelRoute = "/adminPanel";
  static const String categoryRoute = "/category";
  static const String adminsRoute = "/admins";
  static const String profileRoute = "/profile";
  static const String payRoute = "/pay";
  static const String historyRoute = "/history";
  static const String historydetailsRoute = "/historydetails";
  static const String verificationRoute = "/verification";
  static const String freezedWalletsRoute = "/freezedWallets";
  static late String message;

  static late String userId;

  static late List<Transactions> trans;
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.verificationRoute:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.newPasswordRoute:
        return MaterialPageRoute(builder: (_) => const NewPasswordScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.addWalletRoute:
        return MaterialPageRoute(builder: (_) => const AddWalletScreen());
      case Routes.addWalletSuccessRoute:
        return MaterialPageRoute(
            builder: (_) => SuccessScreen(
                  message: Routes.message,
                ));
      case Routes.walletMemberRoute:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case Routes.membersRoute:
        return MaterialPageRoute(builder: (_) => const MembersScreen());
      case Routes.viewersRoute:
        return MaterialPageRoute(builder: (_) => const ViewersScreen());
      case Routes.adminPanelRoute:
        return MaterialPageRoute(builder: (_) => const AdminPanelScreen());
      case Routes.categoryRoute:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case Routes.profileRoute:
        return MaterialPageRoute(
            builder: (_) => ProfileScreen(
                  userId: Routes.userId,
                ));
      case Routes.adminsRoute:
        return MaterialPageRoute(builder: (_) => const AdminsScreen());
      case Routes.payRoute:
        return MaterialPageRoute(builder: (_) => const PayScreen());
      case Routes.historyRoute:
        return MaterialPageRoute(
            builder: (_) => HistoryScreen(trans: Routes.trans));
      case Routes.freezedWalletsRoute:
        return MaterialPageRoute(builder: (_) => const FreezedWalletsScreen());
      case Routes.historydetailsRoute:
        return MaterialPageRoute(builder: (_) => const HistoryItemDetails());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteManager),
              ),
              body: const Center(
                child: Text(AppStrings.noRouteManager),
              ),
            ));
  }
}
