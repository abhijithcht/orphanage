import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FoodDonation extends StatefulWidget {
  const FoodDonation({super.key});

  @override
  State<FoodDonation> createState() => _FoodDonationState();
}

class _FoodDonationState extends State<FoodDonation> {
  final eventkey = GlobalKey<FormState>();
  final TextEditingController _donor = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _food = TextEditingController();

  late bool status;
  late String message;

  @override
  void initState() {
    status = false;
    message = '';
    super.initState();
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _date.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future submit() async {
    final Map mapedData = {
      'date': _date.text.trim(),
      'donor': _donor.text.trim(),
      'food': _food.text.trim(),
      'uid': uidUser,
    };

    final response =
        await http.post(Uri.parse(URL.donateFoodUser), body: mapedData);
    try {
      if (response.body.isEmpty) {
        setState(() {
          status = false;
          message = 'Empty response from the server.';
        });
      } else {
        final data = jsonDecode(response.body);
        final responseMessage = data['message'];
        final responseError = data['error'];
        if (responseError) {
          setState(() {
            status = false;
            message = responseMessage;
          });
        } else {
          _donor.clear();
          _food.clear();
          _date.clear();
          setState(() {
            status = true;
            message = responseMessage;
          });
        }
      }
    } on FormatException catch (e) {
      print('Error decoding JSON: $e');

      setState(() {
        status = false;
        message = 'check mapped data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('F O O D - D O N A T I O N'),
      ),
      body: Form(
        key: eventkey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TFF(
                controller: _date,
                hintText: 'Date',
                keyboardType: TextInputType.none,
                onTap: () async {
                  await _selectDate(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Date cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _donor,
                hintText: 'Donor name',
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Donor name cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _food,
                hintText: 'Food name',
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Food name cannot be empty';
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ELB(
                onPressed: () {
                  if (eventkey.currentState!.validate()) {
                    setState(() {
                      submit();
                      Navigator.pop(context);
                    });
                  }
                },
                text: 'DONATE',
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
