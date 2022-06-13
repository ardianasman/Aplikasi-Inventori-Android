class DataInventori {
  final String nama;
  final String emailuser;
  final String alamat;

  DataInventori({
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

  factory DataInventori.fromJson(Map<String, dynamic> json) {
    return DataInventori(
      nama: json['namaSupplier'],
      emailuser: json['emailUser'],
      alamat: json['alamatSupplier'],
    );
  }
}
