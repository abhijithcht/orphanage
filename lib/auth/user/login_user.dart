import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final loginKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<void> getUserID() async {
    final shaPre = await SharedPreferences.getInstance();
    await shaPre.setString('get_uid_user', uidUser);
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    uidUser;
    super.initState();
  }

  Future login() async {
    final response = await http.post(Uri.parse(URL.loginUser), headers: {
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
          uidUser = singleUser['id'];
          getUserID();
        }
        if (!mounted) return;
        CSB.show(
          context,
          'Login successful',
        );
        Navigator.pushReplacementNamed(context, '/home1');
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
                    setState(() {
                      login();
                      print('user id is: $uidUser');
                    });
                  }
                },
                text: 'LOGIN',
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register1');
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
