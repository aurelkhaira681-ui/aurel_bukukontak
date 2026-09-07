import 'package:flutter/material.dart';
import '../models/kontak.dart';

class KontakPage extends StatelessWidget {
  final List<Kontak> kontakList;

  const KontakPage({super.key, required this.kontakList});

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
            subtitle: Text('${kontak.email}\n${kontak.noHp}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}