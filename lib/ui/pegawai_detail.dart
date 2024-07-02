import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pegawai_page.dart';
import 'pegawai_update_form.dart';
import '../model/pegawai.dart';
import '../service/pegawai_service.dart';

class PegawaiDetail extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiDetail({super.key, required this.pegawai});

  @override
  State<PegawaiDetail> createState() => PegawaiDetailState();
}

class PegawaiDetailState extends State<PegawaiDetail> {
  Stream<Pegawai> getData() async* {
    Pegawai data = await PegawaiService().getById(widget.pegawai.id.toString());
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Pegawai")),
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
                "Nip : ${snapshot.data.nip}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Nama Pegawai : ${snapshot.data.namaPegawai}",
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
                "Email : ${snapshot.data.email}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Password : ${snapshot.data.password}",
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
                      PegawaiUpdateForm(pegawai: snapshot.data)));
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
                  await PegawaiService().hapus(snapshot.data).then((value) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PegawaiPage()));
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
