class DataJenis {
  final String nama;
  final String emailuser;
  final String deskripsi;

  DataJenis({
    required this.nama,
    required this.emailuser,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    return {
      "namaJenis": nama,
      "emailUser": emailuser,
      "deskripsiJenis": deskripsi,
    };
  }

  factory DataJenis.fromJson(Map<String, dynamic> json) {
    return DataJenis(
      nama: json['namaJenis'],
      emailuser: json['emailUser'],
      deskripsi: json['deskripsiJenis'],
    );
  }
}
