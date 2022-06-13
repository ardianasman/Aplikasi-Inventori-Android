class DataUser {
  final String email;
  final String nama;
  final String password;
  final String nomer;
  final String alamatgudang;
  final String imagepath;

  DataUser({
    required this.email,
    required this.nama,
    required this.password,
    required this.nomer,
    required this.alamatgudang,
    required this.imagepath,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "nama": nama,
      "password": password,
      "nomer": nomer,
      "alamatgudang": alamatgudang,
      "imagepath": imagepath,
    };
  }

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      email: json['email'],
      nama: json['nama'],
      password: json['password'],
      nomer: json['nomer'],
      alamatgudang: json['alamatgudang'],
      imagepath: json['imagepath'],
    );
  }
}
