import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    if (index == 0) {
      Navigator.pop(context); // Go back to the previous screen (Home)
    } else if (index == 1) {
      // You are already on the AboutPage, so no need to navigate
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tentang FuTra',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                padding: EdgeInsets.all(5.0),
                child: Image.asset('assets/images/lomo.png', width: 300, height: 200),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'FuTra (Fuel Tracking) adalah sebuah aplikasi canggih yang dirancang khusus untuk memantau dan mengelola penggunaan Bahan Bakar Minyak (BBM) di Unit Pelaksana Pengatur Beban (UP2B). Aplikasi ini bertujuan untuk meningkatkan efisiensi operasional, mengurangi pemborosan, dan memastikan ketersediaan bahan bakar yang optimal. Dengan FuTra, pengguna dapat memonitor konsumsi BBM secara real-time, melacak pengiriman dan penyimpanan, serta mendapatkan laporan yang komprehensif tentang penggunaan bahan bakar.',
                  textAlign: TextAlign.justify,
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
              SizedBox(height: 20),
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
                            Image.asset('assets/images/pln.png', width: 100, height: 100),
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
                            Image.asset('assets/images/polinema.png', width: 100, height: 100),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }
}
