import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A D M I N'),
        actions: [
          IconButton(
            onPressed: () async {
              final shaPre = await SharedPreferences.getInstance();
              shaPre.remove('get_id');

              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login2');
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
                title: const Text('Add Events'),
                onTap: () {
                  Navigator.pushNamed(context, '/add-event');
                },
              ),
              ListTile(
                title: const Text('Update and Delete Events'),
                onTap: () {
                  Navigator.pushNamed(context, '/delete-event');
                },
              ),
              ListTile(
                title: const Text('Cancel food bookings'),
                onTap: () {
                  Navigator.pushNamed(context, '/food-cancel');
                },
              ),
              ListTile(
                title: const Text('Add item to craft shop'),
                onTap: () {
                  Navigator.pushNamed(context, '/add-craft');
                },
              ),
              ListTile(
                title: const Text('Update craft shop item'),
                onTap: () {
                  Navigator.pushNamed(context, '/delete-craft');
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Image.asset('assets/images/1.jpg'),
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
              ),
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
                  Navigator.pushNamed(context, '/craft2');
                },
                child: const Text('View Crafts'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
