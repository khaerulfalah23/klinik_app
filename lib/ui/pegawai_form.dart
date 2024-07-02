import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/pegawai.dart';
import '../service/pegawai_service.dart';
import 'pegawai_detail.dart';

class PegawaiForm extends StatefulWidget {
  @override
  _PegawaiFormState createState() => _PegawaiFormState();
}

class _PegawaiFormState extends State<PegawaiForm> {
  final _formKey = GlobalKey<FormState>();
  final _nipCtrl = TextEditingController();
  final _namaPegawaiCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pegawai")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _fieldNip(),
                _fieldNamaPegawai(),
                _fieldTanggalLahir(),
                _fieldNomorTelepon(),
                _fieldEmail(),
                _fieldPassword(),
                SizedBox(height: 20),
                _tombolSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldNip() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "NIP"),
      controller: _nipCtrl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'NIP tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldNamaPegawai() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Pegawai"),
      controller: _namaPegawaiCtrl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama Pegawai tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldTanggalLahir() {
    return TextFormField(
      decoration:
          const InputDecoration(labelText: "Tanggal Lahir (dd-MM-yyyy)"),
      controller: _tanggalLahirCtrl,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal lahir tidak boleh kosong';
        }
        try {
          DateFormat('dd-MM-yyyy').parseStrict(value);
        } catch (e) {
          return 'Format tanggal salah';
        }
        return null;
      },
    );
  }

  Widget _fieldNomorTelepon() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nomor Telepon"),
      controller: _nomorTeleponCtrl,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nomor telepon tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldEmail() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldPassword() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      controller: _passwordCtrl,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Pegawai pegawai = Pegawai(
            nip: _nipCtrl.text,
            namaPegawai: _namaPegawaiCtrl.text,
            tanggalLahir:
                DateFormat('dd-MM-yyyy').parseStrict(_tanggalLahirCtrl.text),
            nomorTelepon: _nomorTeleponCtrl.text,
            email: _emailCtrl.text,
            password: _passwordCtrl.text,
          );
          await PegawaiService().simpan(pegawai).then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PegawaiDetail(pegawai: value),
              ),
            );
          });
        }
      },
      child: const Text("Simpan"),
    );
  }
}
