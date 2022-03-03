import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_api/youtube_api.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<YouTubeVideo> youtubeVideos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    youtubeVideos = searchYoutube();
    super.initState();
  }

  List<YouTubeVideo> searchYoutube() async {
    var youtubeAPI =
        YoutubeAPI('${dotenv.env['YOUTUBE_API_KEY']}', maxResults: 50);
    var results = await youtubeAPI.search('호미들', type: 'video');
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Text('hello');
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: youtubeVideos.length),
          )
        ],
      ),
    );
  }
}
