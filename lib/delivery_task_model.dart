class DeliveryTask {
  final int id;
  final String title;
  final String receiptNumber;
  final String destination;
  final String status;
  final bool isCompleted;

  DeliveryTask({
    required this.id,
    required this.title,
    required this.receiptNumber,
    required this.destination,
    required this.status,
    required this.isCompleted,
  });

  // Factory constructor untuk memetakan JSON ke objek Dart
  factory DeliveryTask.fromJson(Map<String, dynamic> json) {
    return DeliveryTask(
      id: json['id'],
      title: json['title'],
      receiptNumber: json['receipt_number'],
      destination: json['destination'],
      status: json['status'],
      isCompleted: json['is_completed'],
    );
  }
}