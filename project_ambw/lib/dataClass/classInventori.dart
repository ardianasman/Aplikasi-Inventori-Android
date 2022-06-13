class DataInventori {
  final String nama;
  final String foto;
  final String jenis;
  final String supplier;
  final String harga;
  final String jumlah;
  final String tanggalmasuk;

  DataInventori({
    required this.nama,
    required this.foto,
    required this.jenis,
    required this.supplier,
    required this.harga,
    required this.jumlah,
    required this.tanggalmasuk,
  });

  Map<String, dynamic> toJson() {
    return {
      "namaBarang": nama,
      "fotoBarang": foto,
      "jenisBarang": jenis,
      "supplierBarang": supplier,
      "hargaBarang": harga,
      "jumlahBarang": jumlah,
      "tanggalMasukBarang": tanggalmasuk,
    };
  }

  factory DataInventori.fromJson(Map<String, dynamic> json) {
    return DataInventori(
      nama: json['namaBarang'],
      foto: json['fotoBarang'],
      jenis: json['jenisBarang'],
      supplier: json['supplierBarang'],
      harga: json['hargaBarang'],
      jumlah: json['jumlahBarang'],
      tanggalmasuk: json['tanggalMasukBarang'],
    );
  }
}
