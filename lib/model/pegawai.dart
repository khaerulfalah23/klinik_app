import 'package:intl/intl.dart';

class Pegawai {
  String? id;
  String nip;
  String namaPegawai;
  DateTime tanggalLahir;
  String nomorTelepon;
  String email;
  String password;

  Pegawai({
    this.id,
    required this.nip,
    required this.namaPegawai,
    required this.tanggalLahir,
    required this.nomorTelepon,
    required this.email,
    required this.password,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      id: json["id"],
      nip: json["nip"],
      namaPegawai: json["nama"],
      tanggalLahir:
          DateTime.fromMillisecondsSinceEpoch(json["tanggal_lahir"] * 1000),
      nomorTelepon: json["nomor_telepon"],
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nip": nip,
      "nama": namaPegawai,
      "tanggal_lahir": tanggalLahir.millisecondsSinceEpoch ~/ 1000,
      "nomor_telepon": nomorTelepon,
      "email": email,
      "password": password,
    };
  }
}
