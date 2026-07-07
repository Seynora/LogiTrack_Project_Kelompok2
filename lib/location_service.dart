import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    // 1. Cek apakah layanan lokasi aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak aktif.');
    }
    // 2. Cek izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin akses lokasi ditolak.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Izin ditolak permanen
      return Future.error(
        'Izin lokasi ditolak secara permanen, harap aktifkan dari pengaturan.',
      );
    }
    // 3. Jika semua pengecekan berhasil, dapatkan lokasi
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
