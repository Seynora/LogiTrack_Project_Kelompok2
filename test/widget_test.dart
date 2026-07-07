import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:logitrack_app/login_page.dart';
import 'package:logitrack_app/dashboard_page.dart';
import 'package:logitrack_app/api_service.dart';
import 'package:logitrack_app/delivery_task_model.dart';

class FakeApiService extends ApiService {
  @override
  Future<List<DeliveryTask>> fetchTasks() async {
    return [];
  }
}

void main() {
  testWidgets('Login page builds without error', (WidgetTester tester) async {
    // Build the login page in a MaterialApp and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify that the login page builds and shows the login page
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Login page has required widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Check for email and password fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping), findsOneWidget);
  });

  testWidgets('Dashboard page has QR scanner icon', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DashboardPage(apiService: FakeApiService()),
    ));

    // Verify DashboardPage is present
    expect(find.byType(DashboardPage), findsOneWidget);

    // Verify QR scanner icon is present
    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
  });
}
