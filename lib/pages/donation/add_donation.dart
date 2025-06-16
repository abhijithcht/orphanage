import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;

class DonationAdd extends StatefulWidget {
  const DonationAdd({super.key});

  @override
  State<DonationAdd> createState() => _DonationAddState();
}

class _DonationAddState extends State<DonationAdd> {
  final donationKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _bank = TextEditingController();
  final TextEditingController _account = TextEditingController();

  late bool status;
  late String message;

  @override
  void initState() {
    status = false;
    message = '';
    super.initState();
  }

  Future submit() async {
    final Map mapedData = {
      'name': _name.text.trim(),
      'place': _place.text.trim(),
      'phone': _phone.text.trim(),
      'amount': _amount.text.trim(),
      'bank': _bank.text.trim(),
      'account': _account.text.trim(),
    };

    final response =
        await http.post(Uri.parse(URL.donateMoneyUser), body: mapedData);
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
          _name.clear();
          _amount.clear();
          _place.clear();
          _phone.clear();
          _bank.clear();
          _account.clear();
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
        title: const Text('D O N A T E - M O N E Y'),
      ),
      body: Form(
        key: donationKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TFF(
                controller: _name,
                hintText: 'Donation name',
                focus: true,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Donation name cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _place,
                hintText: 'Place',
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Place cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _phone,
                hintText: 'Phone number',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Phone number cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _amount,
                hintText: 'Amount',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Amount cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _bank,
                hintText: 'Bank name',
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bank name cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _account,
                hintText: 'Account number',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bank name cannot be empty';
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ELB(
                onPressed: () {
                  if (donationKey.currentState!.validate()) {
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
              Text(status ? message : message)
            ],
          ),
        ),
      ),
    );
  }
}
