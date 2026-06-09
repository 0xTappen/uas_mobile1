import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class MatakuliahPage extends StatefulWidget {
  const MatakuliahPage({super.key});

  @override
  State<MatakuliahPage> createState() => _MatakuliahPageState();
}

class _MatakuliahPageState extends State<MatakuliahPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _matakuliah = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatakuliah();
  }

  Future<void> _loadMatakuliah() async {
    final data = await _databaseHelper.getMatakuliah();
    if (!mounted) return;
    setState(() {
      _matakuliah = data;
      _isLoading = false;
    });
  }

  Future<void> _showForm({Map<String, dynamic>? item}) async {
    final kodeController = TextEditingController(text: item?['kode_mk'] ?? '');
    final namaController = TextEditingController(text: item?['nama_mk'] ?? '');
    final sksController = TextEditingController(
      text: item?['sks']?.toString() ?? '',
    );
    final isEdit = item != null;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Matakuliah' : 'Tambah Matakuliah'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: kodeController,
                  decoration: const InputDecoration(labelText: 'Kode MK'),
                ),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama MK'),
                ),
                TextField(
                  controller: sksController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'SKS'),
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
                  'kode_mk': kodeController.text.trim(),
                  'nama_mk': namaController.text.trim(),
                  'sks': int.tryParse(sksController.text.trim()) ?? 0,
                };

                if (isEdit) {
                  await _databaseHelper.updateMatakuliah(
                    item['id'] as int,
                    data,
                  );
                } else {
                  await _databaseHelper.insertMatakuliah(data);
                }

                if (!context.mounted) return;
                Navigator.pop(context);
                await _loadMatakuliah();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    kodeController.dispose();
    namaController.dispose();
    sksController.dispose();
  }

  Future<void> _deleteMatakuliah(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Matakuliah'),
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
      await _databaseHelper.deleteMatakuliah(id);
      await _loadMatakuliah();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matakuliah 2431209')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _matakuliah.isEmpty
          ? const Center(child: Text('Belum ada data matakuliah'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _matakuliah.length,
              itemBuilder: (context, index) {
                final item = _matakuliah[index];
                return Card(
                  child: ListTile(
                    title: Text(item['nama_mk'] ?? ''),
                    subtitle: Text(
                      'Kode: ${item['kode_mk']}\nSKS: ${item['sks']}',
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
                          onPressed: () => _deleteMatakuliah(item['id'] as int),
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
