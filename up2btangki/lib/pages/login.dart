import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up2btangki/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 239, 59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/orang.png', width: 250), // Adjusted image size
            SizedBox(height: 16),
            Text(
              "''Genset Terpantau\ndalam Satu Genggaman''",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 300, // Adjusted button width
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AccessCodeDialog();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5, // Added shadow to the button
                  shadowColor: Colors.black,
                ),
                child: Text("Masuk"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccessCodeDialog extends StatefulWidget {
  @override
  _AccessCodeDialogState createState() => _AccessCodeDialogState();
}

class _AccessCodeDialogState extends State<AccessCodeDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  void _verifyAccessCode(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final DatabaseReference ref = FirebaseDatabase.instance.ref("fuelinformation/token");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final int token = snapshot.value as int;
      if (token == int.parse(_codeController.text)) {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kode akses salah')));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Kode Akses"),
      content: TextField(
        controller: _codeController,
        decoration: InputDecoration(hintText: "Masukkan kode akses"),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  _verifyAccessCode(context);
                },
          child: _isLoading ? CircularProgressIndicator() : Text("Login"),
        ),
      ],
    );
  }
}
