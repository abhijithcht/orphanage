import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;

class CraftShop extends StatefulWidget {
  const CraftShop({super.key});

  @override
  State<CraftShop> createState() => _CraftShopState();
}

class _CraftShopState extends State<CraftShop> {
  Future<List<CraftModel>> getRequest() async {
    final response = await http.get(
      Uri.parse(
        'http://$iPAddress/Hope/admin_craft_display.php',
      ),
    );
    final responseData = json.decode(response.body);
    //Creating a list to store input data;
    final crafts = <CraftModel>[];
    for (final singleUser in responseData) {
      final craft = CraftModel(
        name: singleUser['name'].toString(),
        id: singleUser['id'].toString(),
        craftID: singleUser['craft_id'].toString(),
        price: singleUser['price'].toString(),
        description: singleUser['description'].toString(),
        image: singleUser['image'].toString(),
      );
      crafts.add(craft);
    }
    return crafts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C R A F T - S H O P'),
      ),
      body: FutureBuilder(
        future: getRequest(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
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
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text('No crafts available.'),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    child: ListTile(
                      leading: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data[index].image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        'Name: ${snapshot.data[index].name}',
                      ),
                      subtitle: Text(
                        'Price: ${snapshot.data[index].price}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddToCart(
                              craftID: '${snapshot.data[index].craftID}',
                              name: '${snapshot.data[index].name}',
                              price: '${snapshot.data[index].price}',
                              description: '${snapshot.data[index].description}',
                              image: snapshot.data[index].image,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
