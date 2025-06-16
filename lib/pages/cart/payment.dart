import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({required this.totalAmount, super.key});

  final String totalAmount;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final payKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _total = TextEditingController();
  TextEditingController _bank = TextEditingController();
  TextEditingController _account = TextEditingController();

  late bool status;
  late String message;

  @override
  void initState() {
    _name = TextEditingController();
    _phone = TextEditingController();
    _total = TextEditingController(text: widget.totalAmount);
    _bank = TextEditingController();
    _account = TextEditingController();
    status = false;
    message = '';
    super.initState();
  }

  Future<void> payment() async {
    final var mapedData = <String, String>{
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'bank': _bank.text.trim(),
      'ac_no': _account.text.trim(),
      'total_amt': _total.text.trim(),
      'uid': uidUser,
    };
    final response =
        await http.post(Uri.parse(URL.payment), body: mapedData);
    if (response.body.isEmpty) {
      if (mounted) {
        setState(() {
          status = false;
          message = 'Empty response from the server.';
        });
      }
    } else {
      final data = jsonDecode(response.body);
      final responseMessage = data['message'];
      final responseError = data['error'];
      if (responseError) {
        if (mounted) {
          setState(() {
            status = false;
            message = responseMessage;
          });
        }
      } else {
        _name.clear();
        _phone.clear();
        _total.clear();
        _bank.clear();
        _account.clear();
        if (mounted) {
          setState(() {
            status = true;
            message = responseMessage;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P A Y M E N T'),
      ),
      body: Form(
        key: payKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TFF(
                controller: _name,
                hintText: 'Name',
                focus: true,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Name cannot be empty';
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
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bank name cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _total,
                hintText: 'Amount',
                keyboardType: TextInputType.none,
              ),
              const SizedBox(
                height: 30,
              ),
              ELB(
                onPressed: () {
                  if (payKey.currentState!.validate()) {
                    setState(payment);
                  }
                },
                text: 'PAY',
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
