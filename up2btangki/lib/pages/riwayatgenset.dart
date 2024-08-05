import 'package:flutter/material.dart';
import 'package:up2btangki/models/item.dart'; // Import your Item model
import 'package:up2btangki/widgets/card_widgetsperbaikan.dart'; // Import the CardWidgetPerbaikan widget
import 'package:up2btangki/pages/addriwayatgenset.dart';

class RiwayatGenset extends StatefulWidget {
  final List<Item> items; // List of items

  RiwayatGenset({required this.items}); // Constructor

  @override
  _RiwayatGensetState createState() => _RiwayatGensetState();
}

class _RiwayatGensetState extends State<RiwayatGenset> {
  bool _isNewestFirst = true; // Toggle to control sorting

  void _showFilterDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Terbaru'),
              onTap: () {
                setState(() {
                  _isNewestFirst = true;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Terlama'),
              onTap: () {
                setState(() {
                  _isNewestFirst = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );

  }

  @override
  Widget build(BuildContext context) {
    // Sort items based on the toggle
    List<Item> sortedItems = _isNewestFirst
        ? widget.items.reversed.toList()
        : widget.items.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Set AppBar background color to yellow
        title: Text(
          'Perbaikan Genset',
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: sortedItems.isEmpty
          ? Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: sortedItems.length,
              itemBuilder: (context, index) {
                return CardWidgetPerbaikan(item: sortedItems[index]);
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
