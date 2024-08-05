import 'package:flutter/material.dart';  // Perbaikan impor

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text(
          'Tentang FuTra',
          style: TextStyle(
            fontFamily: 'Poppins', // Using the built-in Roboto font
            fontSize: 20, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
        backgroundColor: Colors.yellow, // Set the background color of the AppBar
        foregroundColor: Colors.black, // Set the color of the text and icons
      ),
      body: SingleChildScrollView( // Add SingleChildScrollView
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Reduce the space from the top
              Container(
                margin: EdgeInsets.only(top: 5.0), // Adjust margin to control the space around the logo
                padding: EdgeInsets.all(5.0), // Adjust padding to control the space inside the container
                child: Image.asset('assets/images/lomo.png', width: 300, height: 200), // Larger logo
              ),
              SizedBox(height: 10), // Add some space between the image and text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'FuTra (Fuel Tracking) adalah sebuah aplikasi canggih yang dirancang khusus untuk memantau dan mengelola penggunaan Bahan Bakar Minyak (BBM) di Unit Pelaksana Pengatur Beban (UP2B). Aplikasi ini bertujuan untuk meningkatkan efisiensi operasional, mengurangi pemborosan, dan memastikan ketersediaan bahan bakar yang optimal. Dengan FuTra, pengguna dapat memonitor konsumsi BBM secara real-time, melacak pengiriman dan penyimpanan, serta mendapatkan laporan yang komprehensif tentang penggunaan bahan bakar.',
                  textAlign: TextAlign.justify, // Justify the text
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fitur Utama:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 6),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Monitoring Real-Time: FuTra memungkinkan pengguna untuk memantau konsumsi BBM secara langsung, memberikan data yang akurat dan terkini tentang jumlah bahan bakar yang digunakan dan tersisa.',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 6),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Laporan Komprehensif: FuTra menyediakan laporan yang detail dan mudah dipahami tentang penggunaan BBM, tren konsumsi, dan analisis efisiensi. Laporan ini dapat diakses kapan saja untuk membantu pengambilan keputusan yang lebih baik.',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Add some space before the bottom content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Mitra Kami:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Image.asset('assets/images/pln.png', width: 100, height: 100), // Left image
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Dirancang oleh:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Image.asset('assets/images/polinema.png', width: 100, height: 100), // Right image
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
