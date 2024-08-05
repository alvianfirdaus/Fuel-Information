import 'package:flutter/material.dart';
import 'package:up2btangki/models/item.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database

class CardWidgetPerbaikan extends StatelessWidget {
  final Item item;

  const CardWidgetPerbaikan({required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.reference), // Use the unique reference as the key
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        _deleteItem(context);
      },
      child: InkWell(
        onLongPress: () {
          Navigator.pushNamed(context, '/item', arguments: item);
        },
        child: Card(
          color: Color.fromARGB(255, 245, 245, 245),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(8),
            title: Text(
              '${item.keterangan}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff4a4a4a),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.nama}', // Display item.nama below item.keterangan
                  style: TextStyle(
                    fontSize: 15, // Match the title font size
                    fontWeight: FontWeight.w700, // Match the title font weight
                    color: Color(0xff4a4a4a),
                  ),
                ),
                SizedBox(height: 4), // Add space between the keterangan and nama
                Text(
                  '${item.tanggal}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                _showDetailDialog(context);
              },
              child: Icon(
                Icons.info_outline,
                color: Color(0xff4a4a4a),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 297,
            height: 220,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 243, 229, 33),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Detail Perbaikan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Teknisi: ${item.nama}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Tanggal: ${item.tanggal}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Waktu: ${item.waktu} '),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Keterangan: ${item.keterangan} '),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteItem(BuildContext context) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('xmaintenance');

    // Debug print the reference being used
    print('Deleting item with reference: ${item.reference}');

    try {
      await databaseReference.child(item.reference).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deleted successfully'),
        ),
      );
      print('Item successfully deleted');
    } catch (error) {
      print('Error deleting item: $error'); // Print the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item: $error'),
        ),
      );
    }
  }
}
