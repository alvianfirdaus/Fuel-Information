import 'package:flutter/material.dart';
import 'package:up2btangki/models/item.dart';
import 'package:up2btangki/utils.dart';

class CardWidget extends StatelessWidget {
  final List<Item> items;

  const CardWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Menampilkan 2 item per baris
          childAspectRatio: 3.7, // Mengatur rasio lebar-tinggi item
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemCard(item: item);
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Navigator.pushNamed(context, '/item', arguments: item);
      },
      child: Card(
        color: Color.fromARGB(255, 245, 245, 245),
        elevation: 8, // Higher elevation for more shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text(
            'Penggunaan Bahan Bakar Harian',
            style: SafeGoogleFont(
              'Urbanist',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.5999999728,
              color: Color(0xff4a4a4a),
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                'Waktu ${item.waktu}',
                style: SafeGoogleFont(
                  'Urbanist',
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
            child: Text(
              '${item.bbmpemakaian} liter',
              style: SafeGoogleFont(
                'Urbanist',
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                            'Detail',
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
                      child: buildInfoRowWithSizedBox('BBM Awal', '${item.bbmawal} liter'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: buildInfoRowWithSizedBox('BBM Akhir', '${item.bbmakhir} liter'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: buildInfoRowWithSizedBox('Total Pemakaian', '${item.bbmpemakaian} liter'),
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
}
