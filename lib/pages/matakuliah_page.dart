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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(isEdit ? 'Edit Matakuliah' : 'Tambah Matakuliah'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: kodeController,
                  decoration: const InputDecoration(
                    labelText: 'Kode MK',
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama MK',
                    prefixIcon: Icon(Icons.menu_book),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: sksController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'SKS',
                    prefixIcon: Icon(Icons.numbers),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
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
      appBar: AppBar(title: const Text('Kelola Data Matakuliah')),
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
            : _matakuliah.isEmpty
            ? const Center(child: Text('Belum ada data matakuliah'))
            : ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: _matakuliah.length,
                itemBuilder: (context, index) {
                  final item = _matakuliah[index];
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
                              Icons.menu_book,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama_mk'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Kode MK: ${item['kode_mk']}'),
                                const SizedBox(height: 3),
                                Text('SKS: ${item['sks']}'),
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
                                    _deleteMatakuliah(item['id'] as int),
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
