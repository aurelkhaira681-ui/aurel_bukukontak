import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Ganti data di bawah ini dengan profil diri kalian sendiri
    // (gunakan data yang sama dengan tugas profil diri di Pertemuan 2)
    const nama = 'Aurel Khaira Lubna';
    const kelas = 'XII RPL B';
    const sekolah = 'SMK NEGERI 5 SURAKARTA';

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/khaira.jpeg'),
              ),
              const SizedBox(height: 16),
              Text(
                nama,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '$kelas - $sekolah',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}