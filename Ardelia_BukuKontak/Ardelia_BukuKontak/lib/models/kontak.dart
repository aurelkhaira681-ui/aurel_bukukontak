class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String? kategori; // nullable, tidak wajib diisi

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori, // opsional, tanpa 'required'
  });
}