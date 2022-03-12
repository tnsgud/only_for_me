import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    _getStoragePermission();
    super.initState();
  }

  void _getStoragePermission() async {
    var status = await Permission.storage.status;
    print(status);
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  void searchYoutube() async {
    var youtubeAPI =
        YoutubeAPI('${dotenv.env['YOUTUBE_API_KEY']}', maxResults: 50);
    youtubeVideos = await youtubeAPI.search(_controller.text, type: 'video');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
            ),
          ),
          TextButton(
            child: const Text("hell"),
            onPressed: () => _getStoragePermission(),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: youtubeVideos.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => searchYoutube(),
        child: const Icon(Icons.search),
      ),
    );
  }
}
