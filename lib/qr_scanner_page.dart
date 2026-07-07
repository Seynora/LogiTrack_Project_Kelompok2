import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? _scannedData;
  bool _hasScanned = false;

  void _handleScan(String code) {
    if (_hasScanned) return;

    setState(() {
      _hasScanned = true;
      _scannedData = code;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR berhasil dipindai: $code')),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        Navigator.of(context).pop(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isEmpty) {
                  debugPrint('Failed to scan Barcode');
                  return;
                }

                final Barcode barcode = barcodes.first;
                final String? code = barcode.rawValue;
                if (code == null || code.isEmpty) {
                  debugPrint('Failed to scan Barcode');
                  return;
                }

                _handleScan(code);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _scannedData == null
                  ? 'Arahkan kamera ke QR Code'
                  : 'Data terdeteksi: $_scannedData',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}