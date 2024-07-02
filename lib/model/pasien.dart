class Pasien {
  String? id;
  String nomorRm;
  String namaPasien;
  DateTime tanggalLahir;
  String nomorTelepon;
  String alamatPasien;

  Pasien({
    this.id,
    required this.nomorRm,
    required this.namaPasien,
    required this.tanggalLahir,
    required this.nomorTelepon,
    required this.alamatPasien,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
      id: json["id"],
      nomorRm: json["nomor_rm"],
      namaPasien: json["nama"],
      tanggalLahir:
          DateTime.fromMillisecondsSinceEpoch(json["tanggal_lahir"] * 1000),
      nomorTelepon: json["nomor_telepon"],
      alamatPasien: json["alamat"]);

  Map<String, dynamic> toJson() => {
        "nomor_rm": nomorRm,
        "nama": namaPasien,
        "tanggal_lahir": tanggalLahir.millisecondsSinceEpoch ~/ 1000,
        "nomor_telepon": nomorTelepon,
        "alamat": alamatPasien
      };
}
