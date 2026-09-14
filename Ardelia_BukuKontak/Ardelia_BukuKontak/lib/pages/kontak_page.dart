import 'package:flutter/material.dart';
import '../models/kontak.dart';

class KontakPage extends StatelessWidget {
  final List<Kontak> kontakList;
  final void Function(Kontak kontak) onEdit;
  final void Function(Kontak kontak) onDelete;

  const KontakPage({
    super.key,
    required this.kontakList,
    required this.onEdit,
    required this.onDelete,
  });

  // KETENTUAN B: tombol Delete harus menampilkan dialog konfirmasi
  // dengan pilihan Batal / Hapus. Hanya memanggil onDelete jika user
  // benar-benar memilih "Hapus".
  Future<void> _konfirmasiHapus(BuildContext context, Kontak kontak) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kontak'),
        content: Text('Yakin ingin menghapus "${kontak.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      onDelete(kontak);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kontakList.isEmpty) {
      return const Center(
        child: Text('Belum ada kontak. Tekan tombol + untuk menambah.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: kontakList.length,
      itemBuilder: (context, index) {
        final kontak = kontakList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                kontak.nama.isNotEmpty ? kontak.nama[0].toUpperCase() : '?',
              ),
            ),
            title: Text(kontak.nama),
            subtitle: Text(
              '${kontak.email}\n${kontak.noHp}\nKategori: ${kontak.kategori ?? "Tanpa kategori"}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  tooltip: 'Edit',
                  onPressed: () => onEdit(kontak),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Hapus',
                  onPressed: () => _konfirmasiHapus(context, kontak),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}