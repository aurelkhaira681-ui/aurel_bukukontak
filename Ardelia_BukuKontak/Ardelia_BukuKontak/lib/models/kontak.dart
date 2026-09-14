class Kontak {
  // id dipakai untuk menandai kontak secara unik, supaya proses Edit/Delete
  // selalu mengenai kontak yang benar walaupun daftar sedang tersaring oleh
  // fitur pencarian (bukan berdasarkan posisi/index di list).
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final String? kategori; // nullable, tidak wajib diisi

  Kontak({
    String? id,
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori, // opsional, tanpa 'required'
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
}