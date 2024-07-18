class Item {
  final String nik;
  final String nama;
  final String ttl;
  final String jenisKelamin;
  final String golDarah;
  final String alamat;
  final String agama;
  final String kawin;
  final String pekerjaan;
  final String kewarganegaraan;
  final String berlaku;
  final String tanggalsc;
  final String waktusc;
  final String imageUrl;
  final String wajahUrl;
  final String status;

  Item({
    required this.nik,
    required this.nama,
    required this.ttl,
    required this.jenisKelamin,
    required this.golDarah,
    required this.alamat,
    required this.agama,
    required this.kawin,
    required this.pekerjaan,
    required this.kewarganegaraan,
    required this.berlaku,
    required this.tanggalsc,
    required this.waktusc,
    required this.imageUrl,
    required this.wajahUrl,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama': nama,
      'ttl': ttl,
      'jenisKelamin': jenisKelamin,
      'golDarah': golDarah,
      'alamat': alamat,
      'agama': agama,
      'kawin': kawin,
      'pekerjaan': pekerjaan,
      'kewarganegaraan': kewarganegaraan,
      'berlaku': tanggalsc,
      'waktusc': waktusc,
      'imageUrl': imageUrl,
      'wajahUrl': wajahUrl,
      'status': status,
    };
  }

  factory Item.fromJson(Map<String, dynamic> data) {
    return Item(
      nik: data['nik'],
      nama: data['nama'],
      ttl: data['ttl'],
      jenisKelamin: data['jenisKelamin'],
      golDarah: data['golDarah'],
      alamat: data['alamat'],
      agama: data['agama'],
      kawin: data['kawin'],
      pekerjaan: data['pekerjaan'],
      kewarganegaraan: data['kewarganegaraan'],
      berlaku: data['berlaku'],
      waktusc: data['waktusc'],
      imageUrl: data['imageUrl'],
      wajahUrl: data['wajahUrl'],
      status: data['status'],
      tanggalsc: data['berlaku'],
    );
  }
}