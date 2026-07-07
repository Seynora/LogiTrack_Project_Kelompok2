import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logitrack_app/delivery_task_model.dart';

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<DeliveryTask>> fetchTasks() async {
    await Future.delayed(const Duration(seconds: 5)); // Simulasi delay jaringan
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => DeliveryTask.fromJson({
        'id': json['id'],
        'title': json['title'],
        'receipt_number': 'INV-${json['id']}',
        'destination': _getRandomDestination(json['id']),
        'status': json['completed'] ? 'Selesai' : 'Dalam Perjalanan',
        'is_completed': json['completed'],
      })).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  String _getRandomDestination(int id) {
    List<String> destinations = ['Jakarta', 'Bandung', 'Surabaya', 'Medan', 'Yogyakarta', 'Semarang', 'Makassar', 'Palembang', 'Bali', 'Lampung'];
    return destinations[id % destinations.length];
  }
}