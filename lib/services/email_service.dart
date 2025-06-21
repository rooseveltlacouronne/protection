import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

class EmailService {
  Future<void> sendEmail(String imagePath, Map<String, double>? location, String recipientEmail) async {
    final smtpServer = gmail('roosevelt.tbr@gmail.com', 'zkwj ldne jleu qzdj');
    final message = Message()
      ..from = const Address('roosevelt.tbr@gmail.com', 'Protection App')
      ..recipients.add(recipientEmail)
      ..subject = 'Échec de déverrouillage'
      ..text = 'Une tentative de déverrouillage a échoué.\n'
          'Localisation: ${location != null ? 'Lat: ${location['latitude']}, Lon: ${location['longitude']}' : 'Non disponible'}'
      ..attachments.add(FileAttachment(File(imagePath)));

    try {
      await send(message, smtpServer);
      print('Email envoyé avec succès à $recipientEmail');
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'email : $e');
    }
  }
}