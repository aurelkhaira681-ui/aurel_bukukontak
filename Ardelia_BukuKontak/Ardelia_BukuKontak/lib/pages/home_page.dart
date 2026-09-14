import 'dart:async';
import 'package:flutter/material.dart';
import '../models/kontak.dart';
import 'kontak_page.dart';
import 'favorit_page.dart';
import 'tambah_kontak_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Kontak> _kontakList = [];

  final StreamController<String> _searchController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.close();
    super.dispose();
  }

  Future<void> _bukaTambahKontak() async {
    final kontakBaru = await Navigator.push<Kontak>(
      context,
      MaterialPageRoute(builder: (context) => const TambahKontakPage()),
    );

    if (kontakBaru != null) {
      setState(() {
        _kontakList.add(kontakBaru);
      });
      _tabController.animateTo(0);
    }
  }

  // ---------------- EDIT KONTAK ----------------
  Future<void> _editKontak(Kontak kontakLama) async {
    final hasil = await Navigator.push<Kontak>(
      context,
      MaterialPageRoute(
        builder: (context) => TambahKontakPage(kontakLama: kontakLama),
      ),
    );

    if (hasil != null) {
      setState(() {
        // Cari berdasarkan id (bukan index), supaya kontak yang benar yang
        // ter-update walaupun daftar sedang tersaring oleh pencarian.
        final index = _kontakList.indexWhere((k) => k.id == kontakLama.id);
        if (index != -1) {
          _kontakList[index] = hasil;
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kontak berhasil diperbarui')),
      );
    }
  }

  // ---------------- DELETE KONTAK ----------------
  void _hapusKontak(Kontak kontak) {
    setState(() {
      // Hapus berdasarkan id, memastikan kontak yang dipilih (termasuk saat
      // sedang dalam hasil pencarian) yang benar-benar terhapus.
      _kontakList.removeWhere((k) => k.id == kontak.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kontak "${kontak.nama}" telah dihapus')),
    );
  }

  void _pilihMenuDrawer(String menu) {
    Navigator.pop(context);

    switch (menu) {
      case 'kontak':
        _tabController.animateTo(0);
        break;
      case 'favorit':
        _tabController.animateTo(1);
        break;
      case 'tambah':
        _bukaTambahKontak();
        break;
      case 'tentang':
        Navigator.pushNamed(context, '/tentang');
        break;
    }
  }

  Widget _buildKontakTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Cari nama atau kategori...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (teks) {
              _searchController.add(teks);
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<String>(
            stream: _searchController.stream,
            initialData: '',
            builder: (context, snapshot) {
              final keyword = (snapshot.data ?? '').toLowerCase();

              final filteredList = keyword.isEmpty
                  ? _kontakList
                  : _kontakList.where((k) {
                      final namaCocok =
                          k.nama.toLowerCase().contains(keyword);
                      final kategoriCocok =
                          (k.kategori ?? '').toLowerCase().contains(keyword);
                      return namaCocok || kategoriCocok;
                    }).toList();

              // filteredList hanya memengaruhi TAMPILAN. onEdit/onDelete
              // tetap beroperasi pada _kontakList asli lewat pencocokan id
              // di _editKontak/_hapusKontak, jadi kontak yang benar yang
              // ter-update/terhapus walau sedang dalam kondisi tersaring.
              return KontakPage(
                kontakList: filteredList,
                onEdit: _editKontak,
                onDelete: _hapusKontak,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Kontak'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.contacts), text: 'Kontak'),
            Tab(icon: Icon(Icons.star), text: 'Favorit'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person, size: 32),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Buku Kontak',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Kontak'),
              onTap: () => _pilihMenuDrawer('kontak'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Tambah Kontak'),
              onTap: () => _pilihMenuDrawer('tambah'),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorit'),
              onTap: () => _pilihMenuDrawer('favorit'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang'),
              onTap: () => _pilihMenuDrawer('tentang'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKontakTab(),
          const FavoritPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahKontak,
        tooltip: 'Tambah Kontak',
        child: const Icon(Icons.add),
      ),
    );
  }
}