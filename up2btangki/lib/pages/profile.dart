import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    print('Username received: ${widget.username}'); // Debugging statement
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("authentication");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final users = snapshot.value as Map<dynamic, dynamic>;

      bool userFound = false;
      users.forEach((key, value) {
        final user = value as Map<dynamic, dynamic>;
        if (user['username'] == widget.username) {
          userFound = true;
          setState(() {
            _userName = user['nama'];
          });
          print('User found: ${user['nama']}'); // Debugging statement
        }
      });

      if (!userFound) {
        print('User not found');
      }
    } else {
      print('No data found in Firebase');
    }
  }

  void _updatePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implement the password update logic here
      print('Update password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: $_userName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.0),
            Text('Ganti Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildInputField(
                    controller: _oldPasswordController,
                    hintText: 'Masukkan password lama',
                    validationMessage: 'Masukkan password lama',
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  buildInputField(
                    controller: _newPasswordController,
                    hintText: 'Masukkan password baru',
                    validationMessage: 'Masukkan password baru',
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  buildInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Konfirmasi password baru',
                    validationMessage: 'Konfirmasi password baru',
                    obscureText: true,
                  ),
                  SizedBox(height: 24.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow, // Button background color
                        foregroundColor: Colors.black, // Text and icon color
                      ),
                      child: Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String validationMessage,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
