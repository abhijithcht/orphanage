import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;

class DonationView extends StatefulWidget {
  const DonationView({super.key});

  @override
  State<DonationView> createState() => _DonationViewState();
}

class _DonationViewState extends State<DonationView> {
  Future<List<DonationModel>> getRequest() async {
    final response = await http.get(Uri.parse(URL.viewDonationAdmin));
    final responseData = jsonDecode(response.body);

    final donations = <DonationModel>[];
    for (final singleUser in responseData) {
      final donation = DonationModel(
        name: singleUser['name'].toString(),
        place: singleUser['place'].toString(),
        phone: singleUser['phone'].toString(),
        amount: singleUser['amount'].toString(),
        bank: singleUser['bank'].toString(),
        account: singleUser['account'].toString(),
      );
      donations.add(donation);
    }
    return donations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'D O N A T I O N S',
        ),
      ),
      body: FutureBuilder(
        future: getRequest(),
        builder:
            (BuildContext ctx, AsyncSnapshot<List<DonationModel>> snapshot) {
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
              child: Text('No data available.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: ListTile(
                    leading: Text(snapshot.data![index].bank),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].place),
                    trailing: Text(snapshot.data![index].amount),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
