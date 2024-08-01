import 'package:flutter/material.dart';
import 'package:up2btangki/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showFirstLogo = true;

  @override
  void initState() {
    super.initState();
    // Menambahkan delay 3 detik sebelum transisi ke logo kedua
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showFirstLogo = false;
      });
    });

    // Menambahkan delay 5 detik sebelum navigasi ke dashboard
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, Routes.loginscreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 239, 59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _showFirstLogo
                  ? Image.asset(
                      'assets/images/3.png',
                      key: ValueKey(1),
                      width: 170,
                      height: 170,
                    )
                  : Image.asset(
                      'assets/images/logoatas.png', // Ganti dengan path logo kedua
                      key: ValueKey(2),
                      width: 170,
                      height: 170,
                    ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'FuTra @ 2024',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff4a4a4a),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
