class EventModel {

  EventModel({
    required this.id,
    required this.name,
    required this.eventDate,
    required this.eventTime,
    required this.description,
  });
  final String id;
  final String name;
  final String eventDate;
  final String eventTime;
  final String description;
}

class CraftModel {

  CraftModel({
    required this.id,
    required this.name,
    required this.craftID,
    required this.price,
    required this.description,
    required this.image,
  });
  final String id;
  final String name;
  final String craftID;
  final String price;
  final String description;
  final String image;
}

class DonationModel {

  DonationModel({
    required this.name,
    required this.place,
    required this.phone,
    required this.amount,
    required this.bank,
    required this.account,
  });
  final String name;
  final String place;
  final String phone;
  final String amount;
  final String bank;
  final String account;
}

class FoodModel {

  FoodModel({
    required this.id,
    required this.date,
    required this.donor,
    required this.food,
  });
  final String id;
  final String date;
  final String donor;
  final String food;
}

class CartModel {

  CartModel({
    required this.id,
    required this.craftID,
    required this.qty,
    required this.cid,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });
  final String id;
  final String craftID;
  final String qty;
  final String cid;
  final String name;
  final String price;
  final String image;
  final String description;
}
