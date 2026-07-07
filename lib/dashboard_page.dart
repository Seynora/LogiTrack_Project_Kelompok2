import 'package:flutter/material.dart';
import 'package:logitrack_app/api_service.dart';
import 'package:logitrack_app/auth_service.dart';
import 'package:logitrack_app/delivery_task_model.dart';
import 'package:logitrack_app/login_page.dart';
import 'package:logitrack_app/delivery_detail_page.dart';
import 'package:logitrack_app/qr_scanner_page.dart';

class DashboardPage extends StatefulWidget {
  final ApiService? apiService;
  const DashboardPage({super.key, this.apiService});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final ApiService apiService;
  late Future<List<DeliveryTask>> futureTasks;

  @override
  void initState() {
    super.initState();
    apiService = widget.apiService ?? ApiService();
    futureTasks = apiService.fetchTasks();
  }

  Future<void> _refreshTasks() async {
    final tasks = await apiService.fetchTasks();
    setState(() {
      futureTasks = Future.value(tasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pengiriman'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final scannedCode = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => const QRScannerPage()),
              );
              if (scannedCode != null && context.mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hasil Pemindaian: $scannedCode'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final signedOut = await AuthService().signOut();
              if (!mounted) return;
              if (signedOut) {
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DeliveryTask>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada tugas pengiriman'));
          }

          final tasks = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(task.receiptNumber),
                    subtitle: Text('Tujuan: ${task.destination}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryDetailPage(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}