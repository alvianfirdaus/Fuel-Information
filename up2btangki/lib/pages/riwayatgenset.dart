import 'package:flutter/material.dart';
import 'package:up2btangki/models/item.dart'; // Import your Item model
import 'package:up2btangki/widgets/card_widgetsperbaikan.dart'; // Import the CardWidgetPerbaikan widget
import 'package:up2btangki/pages/addriwayatgenset.dart';

class RiwayatGenset extends StatelessWidget {
  final List<Item> items; // List of items

  RiwayatGenset({required this.items}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Set AppBar background color to yellow
        title: Text(
          'Riwayat Genset',
          style: TextStyle(
            color: Colors.black, // Text color
            fontWeight: FontWeight.bold, // Make text bold
          ),
        ),
        centerTitle: true, // Center the title text
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Icon color to match the text
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CardWidgetPerbaikan(item: items[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRiwayatGenset(),
            ),
          );
        },
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
