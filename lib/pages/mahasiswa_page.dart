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
          title: Text(isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: npmController,
                  decoration: const InputDecoration(labelText: 'NPM'),
                ),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: prodiController,
                  decoration: const InputDecoration(labelText: 'Prodi'),
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
      appBar: AppBar(title: const Text('Mahasiswa 2431209')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mahasiswa.isEmpty
          ? const Center(child: Text('Belum ada data mahasiswa'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mahasiswa.length,
              itemBuilder: (context, index) {
                final item = _mahasiswa[index];
                return Card(
                  child: ListTile(
                    title: Text(item['nama'] ?? ''),
                    subtitle: Text(
                      'NPM: ${item['npm']}\nProdi: ${item['prodi']}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showForm(item: item),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _deleteMahasiswa(item['id'] as int),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
