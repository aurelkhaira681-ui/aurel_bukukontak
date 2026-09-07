class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String? kategori;   // <-- baru, nullable

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori,          // <-- tidak pakai 'required', jadi opsional
  });
}