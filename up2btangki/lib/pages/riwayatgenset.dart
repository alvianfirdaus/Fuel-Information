import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase dependencies
import 'package:up2btangki/models/item.dart'; // Import your Item model
import 'package:up2btangki/widgets/card_widgetsperbaikan.dart'; // Import the CardWidgetPerbaikan widget
import 'package:up2btangki/pages/addriwayatgenset.dart';

class RiwayatGenset extends StatefulWidget {
  List<Item> items;

  RiwayatGenset({required this.items}); // Constructor

  @override
  _RiwayatGensetState createState() => _RiwayatGensetState();
}

class _RiwayatGensetState extends State<RiwayatGenset> {
  bool _isNewestFirst = true; // Toggle to control sorting

  @override
  void initState() {
    super.initState();
    _setupRealtimeListener(); // Set up the real-time Firebase listener
  }

  // Set up a real-time listener to automatically update items when Firebase data changes
  void _setupRealtimeListener() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('xmaintenance');
    ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        List<Item> items = [];
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          String date = key; // Assuming the key is the date
          items.add(Item.fromJson(Map<String, dynamic>.from(value as Map<dynamic, dynamic>), date));
        });

        // Sort items by date (ascending by default)
        items.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));

        setState(() {
          widget.items = items;
        });
      }
    });
  }

  // Remove an item and delete it from Firebase
  void _removeItem(Item item) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('xmaintenance').child(item.reference);
    await ref.remove(); // Remove the item from Firebase

    setState(() {
      widget.items.remove(item); // Remove from local list
    });
  }

  // Show a filter dialog to switch between newest and oldest first
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
                title: Text('Terlama'),
                onTap: () {
                  setState(() {
                    _isNewestFirst = false; // Oldest first
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Terbaru'),
                onTap: () {
                  setState(() {
                    _isNewestFirst = true; // Newest first
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

  // Manually reload items (can be used after adding new data)
  Future<void> _reloadItems() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('xmaintenance');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      List<Item> items = [];
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        String date = key;
        items.add(Item.fromJson(Map<String, dynamic>.from(value as Map<dynamic, dynamic>), date));
      });

      // Sort items by date (ascending)
      items.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));

      setState(() {
        widget.items = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort items based on the toggle (newest or oldest first)
    List<Item> sortedItems = _isNewestFirst
        ? widget.items.reversed.toList() // Newest first
        : widget.items.toList(); // Oldest first

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // AppBar background color
        title: Text(
          'Perbaikan Genset',
          style: TextStyle(
            color: Colors.black, // Title color
            fontWeight: FontWeight.bold, // Bold title
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterDialog, // Show filter options
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
                final item = sortedItems[index];
                return CardWidgetPerbaikan(
                  item: item,
                  // Display formatted date in the CardWidget
                  dateText: item.formattedTanggal(),
                  onDelete: () => _removeItem(item), // Handle item deletion
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRiwayatGenset(),
            ),
          );

          await _reloadItems(); // Reload items after adding new data
        },
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
