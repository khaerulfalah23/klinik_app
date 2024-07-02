import 'package:flutter/material.dart';
import 'pasien_detail.dart';
import '../model/pasien.dart';
import '../service/pasien_service.dart';
import 'package:intl/intl.dart';

class PasienUpdateForm extends StatefulWidget {
  final Pasien pasien;

  const PasienUpdateForm({Key? key, required this.pasien}) : super(key: key);

  @override
  _PasienUpdateFormState createState() => _PasienUpdateFormState();
}

class _PasienUpdateFormState extends State<PasienUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomorRmCtrl = TextEditingController();
  final _namaPasienCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _alamatPasienCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final Pasien data =
        await PasienService().getById(widget.pasien.id.toString());
    setState(() {
      _nomorRmCtrl.text = data.nomorRm;
      _namaPasienCtrl.text = data.namaPasien;
      _tanggalLahirCtrl.text =
          DateFormat('dd-MM-yyyy').format(data.tanggalLahir);
      _nomorTeleponCtrl.text = data.nomorTelepon;
      _alamatPasienCtrl.text = data.alamatPasien;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Pasien")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _fieldNomorRm(),
                _fieldNamaPasien(),
                _fieldTanggalLahir(),
                _fieldNomorTelepon(),
                _fieldAlamatPasien(),
                SizedBox(height: 20),
                _tombolSimpan()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldNomorRm() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nomor RM"),
      controller: _nomorRmCtrl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nomor RM tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldNamaPasien() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Pasien"),
      controller: _namaPasienCtrl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama pasien tidak boleh kosong';
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

  Widget _fieldAlamatPasien() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Alamat Pasien"),
      controller: _alamatPasienCtrl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Alamat tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Pasien updatedPasien = Pasien(
            id: widget.pasien.id,
            nomorRm: _nomorRmCtrl.text,
            namaPasien: _namaPasienCtrl.text,
            tanggalLahir:
                DateFormat('dd-MM-yyyy').parseStrict(_tanggalLahirCtrl.text),
            nomorTelepon: _nomorTeleponCtrl.text,
            alamatPasien: _alamatPasienCtrl.text,
          );
          await PasienService()
              .ubah(updatedPasien, updatedPasien.id.toString())
              .then((value) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PasienDetail(pasien: value),
              ),
            );
          });
        }
      },
      child: const Text("Ubah"),
    );
  }
}
