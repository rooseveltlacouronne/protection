import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:protection/screens/configuration.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform; // Pour vérifier la version d'Android

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Future<void> _requestPermissions() async {
    // Liste des permissions à demander
    List<Permission> permissions = [
      Permission.camera,
      Permission.location,
    ];

    // Ajouter Permission.storage uniquement pour Android 9 (API 28) et antérieur
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 28) {
        permissions.add(Permission.storage);
      }
    }

    // Demander les permissions
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Vérifier si toutes les permissions nécessaires sont accordées
    bool allGranted = statuses[Permission.camera]!.isGranted &&
        statuses[Permission.location]!.isGranted;

    // Vérifier Permission.storage uniquement si elle a été demandée
    if (permissions.contains(Permission.storage)) {
      allGranted = allGranted && statuses[Permission.storage]!.isGranted;
    }

    if (allGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Configuration()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toutes les permissions sont requises')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Demande de permissions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Veuillez accorder toutes les permissions pour continuer.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermissions,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}