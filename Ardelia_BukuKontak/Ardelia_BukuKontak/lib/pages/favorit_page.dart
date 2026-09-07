import 'package:flutter/material.dart';

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Ganti dengan data diri kamu sendiri
    const nama = 'khansa qurratu ain';
    const email = 'khansa3221@email.com';
    const noHp = '085159009088';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.favorite),
            ),
            title: const Text(nama),
            subtitle: Text('$email\n$noHp'),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}