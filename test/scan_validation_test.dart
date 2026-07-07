import 'package:flutter_test/flutter_test.dart';
import 'package:logitrack_app/delivery_task_model.dart';

void main() {
  test('scanned QR matches receipt number (trimmed)', () {
    final task = DeliveryTask(
      id: 1,
      title: 'Test Task',
      receiptNumber: 'ABC123',
      destination: 'Jakarta',
      status: 'pending',
      isCompleted: false,
    );

    final scannedCodeExact = 'ABC123';
    final scannedCodeWithSpace = '  ABC123  ';

    expect(scannedCodeExact.trim() == task.receiptNumber.trim(), isTrue);
    expect(scannedCodeWithSpace.trim() == task.receiptNumber.trim(), isTrue);
  });

  test('scanned QR does not match different receipt', () {
    final task = DeliveryTask(
      id: 2,
      title: 'Other Task',
      receiptNumber: 'XYZ789',
      destination: 'Bandung',
      status: 'pending',
      isCompleted: false,
    );

    final scannedCode = 'ABC123';

    expect(scannedCode.trim() == task.receiptNumber.trim(), isFalse);
  });
}
