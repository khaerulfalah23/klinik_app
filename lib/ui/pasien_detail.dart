import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pasien_page.dart';
import 'pasien_update_form.dart';
import '../model/pasien.dart';
import '../service/pasien_service.dart';

class PasienDetail extends StatefulWidget {
  final Pasien pasien;

  const PasienDetail({super.key, required this.pasien});

  @override
  State<PasienDetail> createState() => PasienDetailState();
}

class PasienDetailState extends State<PasienDetail> {
  Stream<Pasien> getData() async* {
    Pasien data = await PasienService().getById(widget.pasien.id.toString());
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Pasien")),
      body: StreamBuilder(
        stream: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Text("Data Kosong");
          }

          return Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Nomor Rumah Sakit : ${snapshot.data.nomorRm}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Nama Pasien : ${snapshot.data.namaPasien}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Tanggal Lahir : ${DateFormat("dd-MM-yyyy").format(snapshot.data.tanggalLahir)}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Nomor Telepon : ${snapshot.data.nomorTelepon}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Alamat : ${snapshot.data.alamatPasien}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_tombolubah(), _tombolhapus()],
              )
            ],
          );
        },
      ),
    );
  }

  _tombolubah() {
    return StreamBuilder(
      stream: getData(),
      builder: (context, AsyncSnapshot snapshot) => ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PasienUpdateForm(pasien: snapshot.data)));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, foregroundColor: Colors.white),
        child: Text("Ubah"),
      ),
    );
  }

  _tombolhapus() {
    return ElevatedButton(
      onPressed: () {
        AlertDialog alertDialog = AlertDialog(
          content: Text("Yakin ingin menghapus data ini?"),
          actions: [
            // tombol ya
            StreamBuilder(
              stream: getData(),
              builder: (context, AsyncSnapshot snapshot) => ElevatedButton(
                onPressed: () async {
                  await PasienService().hapus(snapshot.data).then((value) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PasienPage()));
                  });
                },
                child: Text("YA"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
              ),
            ),

            // tombol batal
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Tidak"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, foregroundColor: Colors.black),
            )
          ],
        );
        showDialog(context: context, builder: (context) => alertDialog);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, foregroundColor: Colors.white),
      child: Text("Hapus"),
    );
  }
}
