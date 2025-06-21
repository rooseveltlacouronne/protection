import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraService {
  Future<String?> takePhoto() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      final controller = CameraController(frontCamera, ResolutionPreset.low);
      await controller.initialize();
      await Future.delayed(const Duration(milliseconds: 1)); // Minimiser l'aperçu
      final image = await controller.takePicture();
      await controller.dispose();
      return image.path;
    } catch (e) {
      print('Erreur lors de la capture : $e');
      return null;
    }
  }
}