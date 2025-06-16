import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('U S E R'),
        title: Text('my id is : $uidUser'),
        actions: [
          IconButton(
            onPressed: () async {
              final shaPre = await SharedPreferences.getInstance();
              shaPre.remove('get_id');

              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login1');
              }
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('HOPE'),
                accountEmail: const Text('ORPHANAGE'),
                currentAccountPicture: Image.asset('assets/images/building.png'),
              ),
              ListTile(
                title: const Text('Donate money'),
                onTap: () {
                  Navigator.pushNamed(context, '/donate');
                },
              ),
              ListTile(
                title: const Text('Donate Food'),
                onTap: () {
                  Navigator.pushNamed(context, '/food');
                },
              ),
              ListTile(
                title: const Text('Cancel food bookings'),
                onTap: () {
                  Navigator.pushNamed(context, '/food-usercancel');
                },
              ),
              ListTile(
                title: const Text('Register events'),
                onTap: () {
                  Navigator.pushNamed(context, '/reg-event');
                },
              ),
              ListTile(
                title: const Text('Cancel events'),
                onTap: () {
                  Navigator.pushNamed(context, '/delete-userevent');
                },
              ),
              ListTile(
                title: const Text('My Orders'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrders()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Image.asset('assets/images/3.jpg'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/view-donate');
                },
                child: const Text('View Donations'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/food-view');
                },
                child: const Text('View Food Donations'),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/view-event');
                },
                child: const Text('View Events'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/craft1');
                },
                child: const Text('View Crafts'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: const Text('View Cart'),
          ),
        ],
      ),
    );
  }
}
