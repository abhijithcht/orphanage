import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hope_orphanage/auth/admin/login_admin.dart';
import 'package:hope_orphanage/pages/home/home_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic sessionAdminKey;

class SplashAdmin extends StatefulWidget {
  const SplashAdmin({super.key});

  @override
  State<SplashAdmin> createState() => _SplashAdminState();
}

class _SplashAdminState extends State<SplashAdmin> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(const Duration(milliseconds: 500), () {
        sessionAdminKey == null
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => const LoginAdmin()))
            : Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => const HomeAdmin()));
      });
    });
    setState(() {});
    super.initState();
  }

  Future getValidationData() async {
    final shaPre = await SharedPreferences.getInstance();
    final obtainedEmail = shaPre.getString('get_id');
    setState(() {
      sessionAdminKey = obtainedEmail;
    });
    if (kDebugMode) {
      print('this is session value $sessionAdminKey');
    }
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
}
