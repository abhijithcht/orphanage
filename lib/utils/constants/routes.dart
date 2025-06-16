import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';

class Routes {
  // Screen names constants
  static const String splash1 = '/splash1';
  static const String splash2 = '/splash2';
  static const String home1 = '/home1';
  static const String home2 = '/home2';
  static const String choice = '/choice';
  static const String login1 = '/login1';
  static const String login2 = '/login2';
  static const String register1 = '/register1';
  static const String register2 = '/register2';
  static const String addCraft = '/add-craft';
  static const String deleteCraft = '/delete-craft';
  static const String addEvent = '/add-event';
  static const String deleteEvent = '/delete-event';
  static const String foodCancel = '/food-cancel';
  static const String donate = '/donate';
  static const String viewDonate = '/view-donate';
  static const String food = '/food';
  static const String foodView = '/food-view';
  static const String regEvent = '/reg-event';
  static const String userEvent = '/user-event';
  static const String viewEvent = '/view-event';
  static const String deleteUserEvent = '/delete-userevent';
  static const String foodUserCancel = '/food-usercancel';
  static const String craft1 = '/craft1';
  static const String craft2 = '/craft2';
  static const String cart = '/cart';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash1:
        return buildPageTransition(const SplashUser());
      case splash2:
        return buildPageTransition(const SplashAdmin());
      case home1:
        return buildPageTransition(const HomeUser());
      case home2:
        return buildPageTransition(const HomeAdmin());
      case choice:
        return buildPageTransition(const ChoiceScreen());
      case login1:
        return buildPageTransition(const LoginUser());
      case login2:
        return buildPageTransition(const LoginAdmin());
      case register1:
        return buildPageTransition(const RegisterUser());
      case register2:
        return buildPageTransition(const RegisterAdmin());
      case addCraft:
        return buildPageTransition(const CraftAdd());
      case deleteCraft:
        return buildPageTransition(const CraftDelete());
      case addEvent:
        return buildPageTransition(const EventAdd());
      case deleteEvent:
        return buildPageTransition(const EventView1());
      case foodCancel:
        return buildPageTransition(const FoodCancel());
      case donate:
        return buildPageTransition(const DonationAdd());
      case viewDonate:
        return buildPageTransition(const DonationView());
      case food:
        return buildPageTransition(const FoodDonation());
      case foodView:
        return buildPageTransition(const FoodView());
      case regEvent:
        return buildPageTransition(const EventRegister());
      case userEvent:
        return buildPageTransition(const EventViewUser());
      case viewEvent:
        return buildPageTransition(const EventView2());
      case deleteUserEvent:
        return buildPageTransition(const EventDeleteUser());
      case foodUserCancel:
        return buildPageTransition(const FoodUserCancel());
      case craft1:
        return buildPageTransition(const CraftShop());
      case craft2:
        return buildPageTransition(const CraftShopAdmin());
      case cart:
        return buildPageTransition(const ViewCart());
      default:
        return null;
    }
  }

  static PageRouteBuilder<dynamic> buildPageTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
