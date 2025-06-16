import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final loginKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future login() async {
    final response = await http.post(Uri.parse(URL.loginAdmin), headers: {
      'Accept': 'application/json'
    }, body: {
      'username': _username.text,
      'password': _password.text,
    });
    try {
      final data = json.decode(response.body);
      if (data != null) {
        for (final singleUser in data) {
          final shaPre =
              await SharedPreferences.getInstance();
          await shaPre.setString('get_id', singleUser['id']);
        }
        if (!mounted) return;
        CSB.show(
          context,
          'Login successful',
        );
        Navigator.pushReplacementNamed(context, '/home2');
      } else {
        if (!mounted) return;
        CSB.show(
          context,
          'Invalid username & password',
        );
      }
    } catch (e) {
      if (!mounted) return;
      CSB.show(
        context,
        'Error: Unable to parse server response',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L O G I N'),
      ),
      body: Form(
        key: loginKey,
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
                    return 'username cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _password,
                hintText: 'Password',
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'password cannot be empty';
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ELB(
                onPressed: () {
                  if (loginKey.currentState!.validate()) {
                    setState(login);
                  }
                },
                text: 'LOGIN',
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register2');
                },
                child: const Text('New user? Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
