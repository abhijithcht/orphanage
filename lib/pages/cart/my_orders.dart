import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  num subTotal = 0;

  Future<List<CartModel>> getRequest() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final ui = sharedPrefs.getString('get_uid_user');
    final url = '${URL.viewOrderedItems}${ui!}';

    final response = await http.get(Uri.parse(url));

    final responseData = json.decode(response.body);

    final users = <CartModel>[];
    for (final singleUser in responseData) {
      final var user = CartModel(
        id: singleUser['id'].toString(),
        name: singleUser['name'].toString(),
        image: singleUser['image'].toString(),
        description: singleUser['description'].toString(),
        craftID: singleUser['craft_id'].toString(),
        price: singleUser['price'].toString(),
        qty: singleUser['qty'].toString(),
        cid: singleUser['cartid'].toString(),
      );
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'M Y  O R D E R S',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder(
              future: getRequest(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == null || snapshot.data == false) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.red.shade900,
                          strokeWidth: 5,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Loading...',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Flexible(
                    child: Column(
                      children: [
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    Card(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            const EdgeInsets.fromLTRB(10, 15, 50, 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                snapshot.data[index].image,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Name: ${snapshot.data[index].name}',
                                                ),
                                                Text(
                                                  'Price: ${snapshot.data[index].price}',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
