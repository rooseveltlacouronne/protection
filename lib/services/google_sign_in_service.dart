import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<String?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      return account?.email;
    } catch (e) {
      print('Erreur lors de la connexion Google : $e');
      return null;
    }
  }
}