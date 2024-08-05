class Item {
  final double awal;
  final double akhir;
  final double konsum;
  final String date; // Add date field
  // final String xnama;
  final String? keterangan;
  final String? nama;
  final String reference;
  final String? tanggal;
  final String? waktu;

  Item({
    required this.awal,
    required this.akhir,
    required this.konsum,
    required this.date,
    // required this.xnama,
    this.keterangan,
    this.nama,
    required this.reference,
    this.tanggal,
    this.waktu,
  });

   factory Item.fromJson(Map<dynamic, dynamic> json, String date) {
    return Item(
      awal: json['awal']?.toDouble() ?? 0.0,
      akhir: json['akhir']?.toDouble() ?? 0.0,
      konsum: json['konsum']?.toDouble() ?? 0.0,
      date: date, // Pass date to the Item
      keterangan: json['keterangan'],
      nama: json['nama'],
      reference: json['reference'],
      tanggal: json['tanggal'],
      waktu: json['waktu'],
    );
  }
}
