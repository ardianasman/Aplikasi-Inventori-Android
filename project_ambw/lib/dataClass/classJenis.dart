class DataJenis {
  final String nama;
  final String deskripsi;

  DataJenis({
    required this.nama,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    return {
      "namaJenis": nama,
      "deskripsiJenis": deskripsi,
    };
  }

  factory DataJenis.fromJson(Map<String, dynamic> json) {
    return DataJenis(
      nama: json['namaJenis'],
      deskripsi: json['deskripsiJenis'],
    );
  }
}
