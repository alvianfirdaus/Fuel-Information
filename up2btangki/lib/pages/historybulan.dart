import 'package:flutter/material.dart';
import 'package:up2btangki/models/itemreal.dart';
import 'package:up2btangki/models/data_service.dart';

class HistoryBulanPage extends StatefulWidget {
  @override
  _HistoryBulanPageState createState() => _HistoryBulanPageState();
}

class _HistoryBulanPageState extends State<HistoryBulanPage> {
  bool _isLoading = false;
  double _totalConsumption = 0.0;
  String _errorMessage = '';
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial fetch or other setup if needed
  }

  void _fetchData(String month, String year) async {
    setState(() {
      _isLoading = true;
      _totalConsumption = 0.0;
      _errorMessage = '';
    });

    try {
      List<ItemReal> items = await DataService.fetchMonthlyData();
      print('Fetched items: $items'); // Debugging line

      if (items.isEmpty) {
        setState(() {
          _errorMessage = 'No data available for the given month and year.';
          _isLoading = false;
        });
        return;
      }

      // Ensure month is always two digits
      String formattedMonth = month.padLeft(2, '0');
      String monthYearKey = '$year\_$formattedMonth'; // Format year and month
      print('MonthYearKey: $monthYearKey'); // Debugging line

      double totalConsumption = items
          .where((item) => item.date.startsWith(monthYearKey))
          .fold(0.0, (sum, item) => sum + (item.konsum ?? 0.0));

      setState(() {
        _totalConsumption = totalConsumption;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _errorMessage = 'Error fetching data. Please try again.';
        _isLoading = false;
      });
    }
  }

  bool _validateInput(String month, String year) {
    final monthRegex = RegExp(r'^\d{2}$');
    final yearRegex = RegExp(r'^\d{4}$');
    return monthRegex.hasMatch(month) && yearRegex.hasMatch(year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Bulanan'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Label for month input
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Masukkan Bulan - mm (contoh: 01)',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            // Input for month with shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _monthController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  hintText: '01',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 30),
            // Label for year input
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Masukkan Tahun - yyyy (contoh: 2003)',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            // Input for year with shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _yearController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  hintText: '2003',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String month = _monthController.text;
                String year = _yearController.text;
                if (_validateInput(month, year)) {
                  _fetchData(month, year);
                } else {
                  setState(() {
                    _errorMessage = 'Please enter valid month and year.';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Cari',
                style: TextStyle(color: Colors.black), // Text color
              ),
            ),
            SizedBox(height: 30),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Text(_errorMessage, style: TextStyle(color: Colors.red))
                    : _totalConsumption > 0
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total pemakaian bulan ini:', style: TextStyle(fontSize: 18)),
                                SizedBox(height: 8),
                                Text('$_totalConsumption Liter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        : Container(), // You can add an empty container to handle no results
          ],
        ),
      ),
    );
  }
}
