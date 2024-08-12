import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up2btangki/models/itemreal.dart';
import 'package:up2btangki/widgets/card_widgets.dart'; // Assuming CardWidget is in this file
import 'package:up2btangki/routes/routes.dart';
import 'dashboard.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<ItemReal> _items = [];
  bool _isSortedDescending = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _databaseReference.child('fuelinformation/zhistory').onValue.listen((event) {
      final dynamic value = event.snapshot.value;
      if (value != null) {
        final Map<dynamic, dynamic> data = value as Map<dynamic, dynamic>;
        List<ItemReal> items = [];
        data.forEach((key, value) {
          final item = ItemReal.fromJson(value as Map<dynamic, dynamic>, key as String);
          items.add(item);
        });
        setState(() {
          _items = items;
          if (_isSortedDescending) {
            _items.sort((a, b) => b.date.compareTo(a.date));
          } else {
            _items.sort((a, b) => a.date.compareTo(b.date));
          }
        });
      }
    });
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Latest'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isSortedDescending = true;
                    _items.sort((a, b) => b.date.compareTo(a.date));
                  });
                },
              ),
              ListTile(
                title: Text('Oldest'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isSortedDescending = false;
                    _items.sort((a, b) => a.date.compareTo(b.date));
                  });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return CardWidget(item: item);
              },
            ),
    );
  }
}
