import 'package:flutter/material.dart';

import 'mahasiswa_page.dart';
import 'matakuliah_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.username});

  final String username;

  void _logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home 2431209'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selamat datang, $username',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Aplikasi CRUD UAS 2431209',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: () =>
                            _openPage(context, const MahasiswaPage()),
                        icon: const Icon(Icons.people),
                        label: const Text('Menu Mahasiswa'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () =>
                            _openPage(context, const MatakuliahPage()),
                        icon: const Icon(Icons.menu_book),
                        label: const Text('Menu Matakuliah'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
