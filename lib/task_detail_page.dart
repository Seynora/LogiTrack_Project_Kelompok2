import 'package:flutter/material.dart';
import 'package:logitrack_app/delivery_task_model.dart';
import 'package:logitrack_app/qr_scanner_page.dart';

class TaskDetailPage extends StatelessWidget {
  final DeliveryTask task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas Pengiriman'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Resi: ${task.receiptNumber}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Tujuan: ${task.destination}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Status: Dalam Pengiriman',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR'),
                onPressed: () async {
                  final scannedCode = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerPage(),
                    ),
                  );

                  if (scannedCode != null && context.mounted) {
                    final isMatch = scannedCode.trim() == task.receiptNumber.trim();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isMatch
                              ? 'QR cocok dengan nomor resi ini.'
                              : 'QR tidak cocok dengan nomor resi ini.',
                        ),
                        backgroundColor: isMatch ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}