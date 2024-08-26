import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up2btangki/pages/dashboard.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 239, 59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/orang.png', width: 250),
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
              width: 300,
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
                  elevation: 5,
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _verifyLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final DatabaseReference ref = FirebaseDatabase.instance.ref("authentication");
    final snapshot = await ref.get();

    bool isAuthenticated = false;

    if (snapshot.exists) {
      final users = snapshot.value as Map<dynamic, dynamic>;

      users.forEach((key, value) {
        final user = value as Map<dynamic, dynamic>;
        if (user['username'] == _usernameController.text &&
            user['password'] == _passwordController.text) {
          isAuthenticated = true;
        }
      });

      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau password salah')),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Masuk",
        textAlign: TextAlign.center,
      ),
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            // autofillHints: [AutofillHints.username],
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: "Masukkan username",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            // autofillHints: [AutofillHints.password],
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Masukkan password",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 218, 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color.fromARGB(255, 253, 218, 13)),
                ),
              ),
            ),
            SizedBox(width: 10), // Optional space between buttons
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _verifyLogin(context);
                    },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 253, 218, 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
