class DataSupplier {
  final String nama;
  final String emailuser;
  final String alamat;

  DataSupplier({
    required this.nama,
    required this.emailuser,
    required this.alamat,
  });

  Map<String, dynamic> toJson() {
    return {
      "namaSupplier": nama,
      "emailUser": emailuser,
      "alamatSupplier": alamat,
    };
  }

  factory DataSupplier.fromJson(Map<String, dynamic> json) {
    return DataSupplier(
      nama: json['namaSupplier'],
      emailuser: json['emailUser'],
      alamat: json['alamatSupplier'],
    );
  }
}
