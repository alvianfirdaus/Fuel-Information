import 'package:flutter/material.dart';
import 'package:up2btangki/models/item.dart';
import 'package:up2btangki/data/data_detail.dart';
import 'package:up2btangki/widgets/card_widgets.dart'; // Assuming the CardWidget is in this file
import 'package:up2btangki/routes/routes.dart';
import 'dashboard.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Item> items = InitialData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.yellow,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'This is the History Page',
                style: TextStyle(fontSize: 24),
              ),
            )
          : CardWidget(items: items),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.yellow,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        },
      ),
    );
  }
}
