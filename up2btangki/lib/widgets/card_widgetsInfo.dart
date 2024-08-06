import 'package:flutter/material.dart';
import 'package:up2btangki/pages/about.dart';
import 'package:up2btangki/pages/akses.dart';
import 'package:up2btangki/pages/genset.dart';
import 'package:up2btangki/pages/ubahkode.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;  // Menambahkan callback untuk onTap

  CardWidget({required this.title, required this.onTap});  // Menambahkan parameter onTap

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios),  // Menambahkan ikon panah kanan
        onTap: onTap,  // Menambahkan onTap
      ),
    );
  }
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),  // Padding di sekitar Info widget
      child: Column(
        children: [
          CardWidget(
            title: 'Tentang FuTra',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          SizedBox(height: 10),  // Jarak antara CardWidget
          CardWidget(
            title: 'Informasi Genset',
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GensetPage()),
              );
            },
          ),
          SizedBox(height: 10),  // Jarak antara CardWidget
          CardWidget(
            title: 'Ubah Kode Akses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UbahKode()),
              );
            },
          ),
        ],
      ),
    );
  }
}
