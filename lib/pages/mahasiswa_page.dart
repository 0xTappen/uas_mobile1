import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _mahasiswa = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMahasiswa();
  }

  Future<void> _loadMahasiswa() async {
    final data = await _databaseHelper.getMahasiswa();
    if (!mounted) return;
    setState(() {
      _mahasiswa = data;
      _isLoading = false;
    });
  }

  Future<void> _showForm({Map<String, dynamic>? item}) async {
    final npmController = TextEditingController(text: item?['npm'] ?? '');
    final namaController = TextEditingController(text: item?['nama'] ?? '');
    final prodiController = TextEditingController(text: item?['prodi'] ?? '');
    final isEdit = item != null;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: npmController,
                  decoration: const InputDecoration(
                    labelText: 'NPM',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: prodiController,
                  decoration: const InputDecoration(
                    labelText: 'Prodi',
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                final data = {
                  'npm': npmController.text.trim(),
                  'nama': namaController.text.trim(),
                  'prodi': prodiController.text.trim(),
                };

                if (isEdit) {
                  await _databaseHelper.updateMahasiswa(
                    item['id'] as int,
                    data,
                  );
                } else {
                  await _databaseHelper.insertMahasiswa(data);
                }

                if (!context.mounted) return;
                Navigator.pop(context);
                await _loadMahasiswa();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    npmController.dispose();
    namaController.dispose();
    prodiController.dispose();
  }

  Future<void> _deleteMahasiswa(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('Hapus Mahasiswa'),
          content: const Text('Yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _databaseHelper.deleteMahasiswa(id);
      await _loadMahasiswa();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Data Mahasiswa')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FB), Color(0xFFEAF0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _mahasiswa.isEmpty
            ? const Center(child: Text('Belum ada data mahasiswa'))
            : ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: _mahasiswa.length,
                itemBuilder: (context, index) {
                  final item = _mahasiswa[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('NPM: ${item['npm']}'),
                                const SizedBox(height: 3),
                                Text('Prodi: ${item['prodi']}'),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => _showForm(item: item),
                                icon: const Icon(Icons.edit),
                                color: Colors.indigo.shade700,
                              ),
                              IconButton(
                                onPressed: () =>
                                    _deleteMahasiswa(item['id'] as int),
                                icon: const Icon(Icons.delete),
                                color: Colors.red.shade600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
