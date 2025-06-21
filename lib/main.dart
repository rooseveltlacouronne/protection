import 'package:flutter/material.dart';
import 'package:protection/screens/permission_screen.dart';
import 'package:protection/screens/configuration.dart';
import 'package:protection/screens/deverouillage.dart';
import 'package:protection/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  final isConfigured = await storageService.isConfigured();

  runApp(MyApp(isConfigured: isConfigured));
}

class MyApp extends StatelessWidget {
  final bool isConfigured;
  const MyApp({super.key, required this.isConfigured});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: isConfigured ? '/deverouillage' : '/',
      routes: {
        '/': (context) => const PermissionScreen(),
        '/deverouillage': (context) => const Deverouillage(),
      },
    );
  }
}
