import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logitrack_app/camera_picker.dart';
import 'package:logitrack_app/delivery_task_model.dart';
import 'package:logitrack_app/qr_scanner_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logitrack_app/location_service.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryDetailPage extends StatefulWidget {
  final DeliveryTask task;

  const DeliveryDetailPage({super.key, required this.task});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  Uint8List? _imageData;
  bool _isLoading = false;
  // ignore: unused_field
  XFile? _imageFile;
  Position? _currentPosition; // State untuk menyimpan posisi
  final LocationService _locationService =
      LocationService(); // Instance service

  Future<void> _pickImageFromCamera() async {
    setState(() => _isLoading = true);

    try {
      final bytes = await pickCameraImage();
      if (bytes != null) {
        setState(() {
          _imageData = bytes;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto berhasil diambil!')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      // ignore: avoid_print
      print("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengakses kamera.')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocationAndCompleteDelivery() async {
    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      if (!mounted) return;
      // Tampilkan notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Pengiriman Selesai di Lat: ${position.latitude}, Lon: ${position.longitude}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Tampilkan notifikasi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${widget.task.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${widget.task.isCompleted ? "Selesai" : "Dalam Proses"}',
            ),
            const SizedBox(height: 24),
            const Text(
              'Bukti Pengiriman:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Area untuk menampilkan gambar atau placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageData == null
                  ? const Center(child: Text('Belum ada gambar'))
                  : Image.memory(_imageData!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil Foto Bukti'),
                onPressed: _isLoading ? null : _pickImageFromCamera,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Widget untuk menampilkan data lokasi
            if (_currentPosition != null)
              Text(
                'Lokasi Terekam:\nLat: ${_currentPosition!.latitude}\nLon: ${_currentPosition!.longitude}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            if (_currentPosition == null)
              const Text(
                'Lokasi belum direkam.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 16),
            // Tombol untuk menyelesaikan pengiriman
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_on),
                label: const Text('Selesaikan Pengiriman & Rekam Lokasi'),
                onPressed: _getCurrentLocationAndCompleteDelivery,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
            const SizedBox(height: 12),
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
                    final isMatch =
                        scannedCode.trim() == widget.task.receiptNumber.trim();
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
          ],
        ),
      ),
    );
  }
}
