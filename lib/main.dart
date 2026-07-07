import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logitrack_app/firebase_options.dart'; // Ditambahkan agar mendukung Web & Android
import 'package:logitrack_app/auth_gate.dart';
import 'package:logitrack_app/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  bool get _hasValidFirebaseOptions {
    final options = DefaultFirebaseOptions.currentPlatform;
    return options.apiKey.isNotEmpty &&
        !options.apiKey.contains('YOUR_') &&
        options.projectId.isNotEmpty &&
        !options.projectId.contains('YOUR_') &&
        options.appId.isNotEmpty &&
        !options.appId.contains('YOUR_');
  }

  late final Future<FirebaseApp?> _initialization = _hasValidFirebaseOptions
      ? Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      : Future<FirebaseApp?>.value(null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<FirebaseApp?>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Jika terjadi error, halaman login akan muncul
            return const LoginPage();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return AuthGate();
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}