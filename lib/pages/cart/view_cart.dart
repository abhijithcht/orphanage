import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  Future<List<CartModel>> getCartDetails() async {
    final shrdprfs = await SharedPreferences.getInstance();
    final ui = shrdprfs.getString('get_id');

    final url = '${URL.viewCartUser}${ui!}';
    final response = await http.get(Uri.parse(url));
    final responseData = jsonDecode(response.body);

    final items = <CartModel>[];
    for (final singleUser in responseData) {
      final item = CartModel(
        id: singleUser['id'].toString(),
        name: singleUser['name'].toString(),
        craftID: singleUser['craft_id'].toString(),
        qty: singleUser['qty'].toString(),
        description: singleUser['description'].toString(),
        cid: singleUser['cartid'].toString(),
        price: singleUser['price'].toString(),
        image: singleUser['image'].toString(),
      );
      items.add(item);
    }
    return items;
  }

  Future deleteData(String id) async {
    final res = await http.post(Uri.parse(URL.deleteCartUser), body: {
      'id': id,
    });
    final response = jsonDecode(res.body);
    if (response['success'] == 'true') {
      print(id);
      getCartDetails();
    } else {
      print('some issue');
    }
  }

  const _style = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M Y  C A R T'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getCartDetails(),
            builder:
                (BuildContext ctx, AsyncSnapshot<List<CartModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red[900],
                    strokeWidth: 5,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No items added to cart.'),
                );
              } else {
                final user = snapshot.data;

                return Flexible(
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (ctx, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data![index].name),
                                leading: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(
                                    snapshot.data![index].image,
                                  ),
                                ),
                                subtitle: Text(
                                    'Price: ${snapshot.data![index].price}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this event?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteData(
                                                    snapshot.data![index].cid);
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.yellow,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'TOTAL',
                                  style: _style,
                                ),
                                Text(
                                  '\$${returnTotalAmount(user!)}',
                                  style: _style,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ELB(
                          text: 'BUY NOW',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Payment(
                                  totalAmount: returnTotalAmount(user),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String returnTotalAmount(List<CartModel> user) {
    var totalAmount = 0;
    for (var i = 0; i < user.length; i++) {
      totalAmount = totalAmount +
          (double.parse(user[i].price) * double.parse(user[i].qty));
    }
    return totalAmount.toString();
  }
}
