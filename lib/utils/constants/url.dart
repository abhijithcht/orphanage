import 'package:hope_orphanage/app_imports.dart';

class URL {
  URL._();

// Admin
  static String loginAdmin = 'http://$iPAddress/Hope/login_admin.php';
  static String registerAdmin = 'http://$iPAddress/Hope/registration_admin.php';
  static String loginUser = 'http://$iPAddress/Hope/login_user.php';
  static String registerUser = 'http://$iPAddress/Hope/registration_user.php';
  static String addToCartUser = 'http://$iPAddress/Hope/user_add_to_cart.php';
  static String payment = 'http://$iPAddress/Hope/payment.php';
  static String deleteCartUser = 'http://$iPAddress/Hope/user_cart_delete.php';
  static String deleteCraftAdmin =
      'http://$iPAddress/Hope/admin_craft_delete.php';
  static String donateMoneyUser =
      'http://$iPAddress/Hope/user_money_donation.php';
  static String eventRegisterAdmin =
      'http://$iPAddress/Hope/event_registration.php';
  static String viewDonationAdmin =
      'http://$iPAddress/Hope/admin_donation.display.php';
  static String viewEventAdmin =
      'http://$iPAddress/Hope/admin_event_display.php';
  static String eventRegisterUser =
      'http://$iPAddress/Hope/user_event_registration.php';
  static String deleteEventAdmin = 'http://$iPAddress/Hope/event_delete.php';
  static String deleteFoodBookingAdmin =
      'http://$iPAddress/Hope/admin_delete_food_bookings.php';
  static String donateFoodUser =
      'http://$iPAddress/Hope/user_food_donation.php';
  static String viewFoodDonationUser =
      'http://$iPAddress/Hope/user_food_donation_display.php';
  static String cancelFoodDonationUser =
      'http://$iPAddress/Hope/cancel_food_donation_user.php?uid=';
  static String cancelEventAdmin =
      'http://$iPAddress/Hope/cancel_event_registration.php?uid=';
  static String viewCartUser = 'http://$iPAddress/Hope/user_view_cart.php?uid=';
  static String viewOrderedItems =
      'http://$iPAddress/Hope/Display_order_items.php?uid=';
}
