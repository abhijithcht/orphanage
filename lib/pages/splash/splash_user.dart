import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic sessionUserKey;

class SplashUser extends StatefulWidget {
  const SplashUser({super.key});

  @override
  State<SplashUser> createState() => _SplashUserState();
}

class _SplashUserState extends State<SplashUser> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(const Duration(milliseconds: 500), () {
        sessionUserKey == null
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const LoginUser()),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const HomeUser()),
              );
      });
    });
    setState(getUserID);
    super.initState();
  }

  Future<void> getValidationData() async {
    final shaPre = await SharedPreferences.getInstance();
    final obtainedEmail = shaPre.getString('get_id');
    setState(() {
      sessionUserKey = obtainedEmail;
    });
    print('this is session value $sessionUserKey');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading'),
            SizedBox(height: 10),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserID() async {
    final shaPre = await SharedPreferences.getInstance();
    final obtainid = shaPre.getString('get_uid_user');
    setState(() {
      uidUser = obtainid!;
    });
  }
}
