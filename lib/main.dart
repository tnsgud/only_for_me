import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  // Future<UserCredential> signInWithGitHub() async {
  //   // Create a GitHubSignIn instance
  //   final GitHubSignIn gitHubSignIn = GitHubSignIn(
  //       clientId: '98f368c528a09afca514',
  //       clientSecret: 'a788ba6110294584cc915c2ad2b13181c8021910',
  //       redirectUrl: 'https://my-project.firebaseapp.com/__/auth/handler');

  //   // Trigger the sign-in flow
  //   final result = await gitHubSignIn.signIn(context);

  //   // Create a credential from the access token
  //   final githubAuthCredential = GithubAuthProvider.credential(result.token);

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(githubAuthCredential);
  // }

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
              width: 150,
              child: TextButton(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: textWithNotoSans(
                    data: '로그인',
                    fontSize: 20,
                  ),
                ),
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.deepPurple[400],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
