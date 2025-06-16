import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;

class RegisterAdmin extends StatefulWidget {
  const RegisterAdmin({super.key});

  @override
  State<RegisterAdmin> createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  final registerKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

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
      'username': _username.text,
      'email': _email.text,
      'phone': _phone.text,
      'password': _password.text,
    };

    final var response =
        await http.post(Uri.parse(URL.registerAdmin), body: mapedData);
    final data = jsonDecode(response.body);
    final responseMessage = data['message'];
    final responseError = data['error'];
    if (responseError) {
      setState(() {
        status = false;
        message = responseMessage;
      });
    } else {
      _username.clear();
      _password.clear();
      _email.clear();
      _phone.clear();
      _confirmPassword.clear();
      setState(() {
        status = true;
        message = responseMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('R E G I S T R A T I O N'),
      ),
      body: Form(
        key: registerKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TFF(
                controller: _username,
                hintText: 'Username',
                focus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Username cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _email,
                hintText: 'Email address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'email cannot be empty';
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
                    return 'phone number cannot be empty';
                  }
                  if (value!.length != 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              TFF(
                controller: _password,
                hintText: 'Password',
                obscure: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'password cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _confirmPassword,
                hintText: 'Confirm password',
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'password cannot be empty';
                  }
                  if (_password.text != _confirmPassword.text) {
                    return "Passwords doesn't match";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ELB(
                onPressed: () {
                  if (registerKey.currentState!.validate()) {
                    setState(submit);
                  }
                },
                text: 'REGISTER',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                status ? message : message,
                style: TextStyle(
                  color: status ? Colors.green : Colors.red,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login2');
                },
                child: const Text('Already an User? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
