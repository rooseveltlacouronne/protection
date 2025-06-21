import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protection/services/auth_service.dart';
import 'package:protection/services/camera_service.dart';
import 'package:protection/services/email_service.dart';
import 'package:protection/services/location_service.dart';

class Deverouillage extends StatefulWidget {
  const Deverouillage({super.key});

  @override
  _DeverouillageState createState() => _DeverouillageState();
}

class _DeverouillageState extends State<Deverouillage> {
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _cameraService = CameraService();
  final _emailService = EmailService();
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    // Masque la barre système et empêche l'utilisateur de quitter
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Blocage du bouton retour Android
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.blue.shade500],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Déverrouiller l\'appareil',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final isValid = await _authService.verifyPassword(_passwordController.text);
                      if (isValid) {
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                        SystemNavigator.pop(); // Ferme l’application
                        const platform = MethodChannel('com.example.protection/lock');

await platform.invokeMethod('stopLockTask');
SystemNavigator.pop();

                      } else {
                        final imagePath = await _cameraService.takePhoto();
                        final location = await _locationService.getLocation();
                        final email = await _authService.getEmail();
                        if (imagePath != null && email != null) {
                          await _emailService.sendEmail(imagePath, location, email);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mot de passe incorrect')),
                        );
                      }
                    },
                    child: const Text('Déverrouiller', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
