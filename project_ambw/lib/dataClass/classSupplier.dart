class DataSupplier {
  final String nama;
  final String emailuser;
  final String alamat;
  final String namabarang;
  final String gambarSupplier;

  DataSupplier({
    required this.nama,
    required this.emailuser,
    required this.alamat,
    required this.namabarang,
    required this.gambarSupplier,
  });

  Map<String, dynamic> toJson() {
    return {
      "namaSupplier": nama,
      "emailUser": emailuser,
      "alamatSupplier": alamat,
      "namaBarang": namabarang,
      "foto": gambarSupplier,
    };
  }

  factory DataSupplier.fromJson(Map<String, dynamic> json) {
    return DataSupplier(
      nama: json['namaSupplier'],
      emailuser: json['emailUser'],
      alamat: json['alamatSupplier'],
      namabarang: json['namaBarang'],
      gambarSupplier: json['foto'],
    );
  }
}
