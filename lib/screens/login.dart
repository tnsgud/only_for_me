import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Text textWithNotoSans({
    required String data,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.center,
    Color? color = Colors.white,
  }) {
    return Text(
      data,
      style: GoogleFonts.notoSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: textWithNotoSans(
                data: 'Only For Me',
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              subtitle: textWithNotoSans(
                data: '나를 위한 음악서비스',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 200,
              child: TextButton.icon(
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                ),
                label: textWithNotoSans(data: '구글로 로그인', fontSize: 20),
                onPressed: signInWithGoogle,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.deepPurple[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
