import 'package:flutter/material.dart';
import 'package:up2btangki/pages/info.dart';

class GensetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Set AppBar background color to yellow
        title: Text(
          'Informasi Genset',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(40.0),
              width: double.infinity, // Make the image container take up the full width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    blurRadius: 10.0, // Shadow blur radius
                    offset: Offset(0, 4), // Shadow offset
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Apply same rounded corners
                child: Image.asset(
                  'assets/images/genset.jpg', // Replace with your image asset
                  fit: BoxFit.cover, // Ensure the image covers the container
                  width: 330, // Set the width
                  height: 330, // Set the height
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center( // Center the text
                    child: Text(
                      'Genset UIT JBM & UP2B JAWA TIMUR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GensetInfoRow(label: 'Merk', value: 'Mitsubishi'),
                  GensetInfoRow(label: 'Type', value: 'GFC5316E-4'),
                  GensetInfoRow(label: 'Output', value: '250 kVA'),
                  GensetInfoRow(label: 'Volt', value: '380'),
                  GensetInfoRow(label: 'Ampere', value: '380'),
                  Row(
                    children: [
                      Text(
                        'Riwayat Perbaikan',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          // Handle tap
                        },
                        child: Text(
                          'Lihat',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GensetInfoRow extends StatelessWidget {
  final String label;
  final String value;

  GensetInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label :',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
