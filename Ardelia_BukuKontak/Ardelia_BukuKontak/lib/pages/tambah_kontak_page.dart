import 'package:flutter/material.dart';
import '../models/kontak.dart';

class TambahKontakPage extends StatefulWidget {
  // Jika kontakLama diisi -> halaman ini berfungsi sebagai form EDIT
  // (form otomatis terisi data lama). Jika null -> form TAMBAH biasa.
  final Kontak? kontakLama;

  const TambahKontakPage({super.key, this.kontakLama});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController hpController;
  late final TextEditingController kategoriController;

  bool get _isEdit => widget.kontakLama != null;

  @override
  void initState() {
    super.initState();
    // Form Edit harus menampilkan data kontak yang sebelumnya sudah tersimpan.
    final k = widget.kontakLama;
    namaController = TextEditingController(text: k?.nama ?? '');
    emailController = TextEditingController(text: k?.email ?? '');
    hpController = TextEditingController(text: k?.noHp ?? '');
    kategoriController = TextEditingController(text: k?.kategori ?? '');
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  void _simpanKontak() {
    if (_formKey.currentState!.validate()) {
      final kontakHasil = Kontak(
        // Pertahankan id lama saat edit, supaya kontak yang diperbarui
        // adalah kontak yang sama persis (bukan dianggap kontak baru).
        id: widget.kontakLama?.id,
        nama: namaController.text,
        email: emailController.text,
        noHp: hpController.text,
        kategori: kategoriController.text.isEmpty
            ? null
            : kategoriController.text,
      );
      Navigator.pop(context, kontakHasil);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Kontak' : 'Tambah Kontak')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama - wajib diisi
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email - wajib diisi dan harus mengandung '@'
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung karakter "@"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // No HP - hanya angka, minimal 10 digit
              TextFormField(
                controller: hpController,
                decoration: const InputDecoration(
                  labelText: 'No. Handphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No. HP wajib diisi';
                  }
                  final hanyaAngka = RegExp(r'^[0-9]+$');
                  if (!hanyaAngka.hasMatch(value)) {
                    return 'No. HP hanya boleh berisi angka';
                  }
                  if (value.length < 10) {
                    return 'No. HP minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Kategori - opsional, tanpa validator
              TextFormField(
                controller: kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (opsional: Keluarga/Teman/Kerja)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanKontak,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}