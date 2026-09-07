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

              return KontakPage(kontakList: filteredList);
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