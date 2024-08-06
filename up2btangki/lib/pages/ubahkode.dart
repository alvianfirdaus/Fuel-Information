import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class UbahKode extends StatefulWidget {
  @override
  _UbahKodeState createState() => _UbahKodeState();
}

class _UbahKodeState extends State<UbahKode> {
  final _formKey = GlobalKey<FormState>();
  final _oldCodeController = TextEditingController();
  final _newCodeController = TextEditingController();
  final _confirmCodeController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> _updateToken() async {
    if (_formKey.currentState!.validate()) {
      int oldCode = int.tryParse(_oldCodeController.text) ?? -1;
      int newCode = int.tryParse(_newCodeController.text) ?? -1;

      if (oldCode == -1 || newCode == -1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kode akses harus berupa angka.')));
        return;
      }

      // Fetch the current token from Firebase
      DataSnapshot snapshot = await _database.child('fuelinformation/token').get();
      int currentToken = snapshot.value as int;

      if (oldCode == currentToken) {
        // Update the token in Firebase
        await _database.child('fuelinformation/token').set(newCode);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kode akses berhasil diubah.')));

        // Redirect to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kode akses lama tidak sesuai.')));
      }
    }
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String validationMessage,
    required bool obscureText,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Center(
          child: Text(
            'Ubah Kode Akses',
            style: TextStyle(
              fontSize: 20, // Adjust the size as needed
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    'Masukkan Kode Akses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Masukkan kode akses sebelumnya',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                buildInputField(
                  controller: _oldCodeController,
                  hintText: 'Masukkan kode akses lama',
                  validationMessage: 'Masukkan kode akses lama',
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Masukkan kode akses terbaru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                buildInputField(
                  controller: _newCodeController,
                  hintText: 'Masukkan kode akses baru',
                  validationMessage: 'Masukkan kode akses baru',
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Konfirmasi kode akses terbaru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                buildInputField(
                  controller: _confirmCodeController,
                  hintText: 'Konfirmasi kode akses baru',
                  validationMessage: 'Konfirmasi kode akses baru',
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateToken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Background color
                      foregroundColor: Colors.black, // Text color
                    ),
                    child: Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
