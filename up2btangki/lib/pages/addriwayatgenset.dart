import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddRiwayatGenset extends StatefulWidget {
  @override
  _AddRiwayatGensetState createState() => _AddRiwayatGensetState();
}

class _AddRiwayatGensetState extends State<AddRiwayatGenset> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _waktuController = TextEditingController();
  final _keteranganController = TextEditingController();

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('xmaintenance');

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      // Generate a unique reference key
      String uniqueReference = "REF-${DateTime.now().millisecondsSinceEpoch}";

      // Create a Map with the data to save
      Map<String, dynamic> dataToSave = {
        'reference': uniqueReference,
        'nama': _namaController.text,
        'tanggal': _tanggalController.text,
        'waktu': _waktuController.text,
        'keterangan': _keteranganController.text,
      };

      try {
        // Save data under the unique reference key
        await _databaseReference.child(uniqueReference).set(dataToSave);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan')),
        );
        Navigator.of(context).pop();
      } catch (error) {
        print('Failed to save data: $error'); // Print the error for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Set AppBar background color to yellow
        title: Text(
          'Tambah Riwayat Perbaikan',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan Nama',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  hintText: 'Masukkan Tanggal',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _waktuController,
                decoration: InputDecoration(
                  labelText: 'Waktu',
                  hintText: 'Masukkan Waktu',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Waktu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Uraian Kegiatan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Background color
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
