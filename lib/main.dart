import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
  List<String> demo = [];
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _getStoragePermission();
    super.initState();
  }

  void _getStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  void _downloadYoutubeAudio({
    required String videoId,
    required String path,
  }) async {
    var manifest =
        await YoutubeExplode().videos.streamsClient.getManifest(videoId);
    var streamInfo = manifest.audioOnly.withHighestBitrate();
    _writeFile(streamInfo: streamInfo, path: path);
  }

  void _writeFile({
    required AudioOnlyStreamInfo streamInfo,
    required String path,
  }) async {
    var stream = YoutubeExplode().videos.streamsClient.get(streamInfo);
    var file = File(path);
    var fileStream = file.openWrite();

    await stream.pipe(fileStream);

    await fileStream.flush();
    await fileStream.close();
  }

  Future<String> _fetch1() async {
    await Future.delayed(const Duration(seconds: 5));

    return 'Hello';
  }

  Future searchYoutube() async {
    if (_controller.text.isEmpty) {
      return;
    }

    await Future.delayed(const Duration(seconds: 5));
    var youtubeAPI = YoutubeAPI(
      '${dotenv.env['YOUTUBE_API_KEY']}',
      maxResults: 50,
    );

    youtubeVideos = await youtubeAPI.search(
      _controller.text,
      type: 'video',
    );
  }

  Future demoMethod() async {
    await Future.delayed(const Duration(seconds: 5));

    for (var i = 0; i < 10; i++) {
      demo.add('$i');
    }

    return demo;
  }

  get _getExternalDir async {
    var _externalStorageDirectory = await getExternalStorageDirectory();
    return _externalStorageDirectory?.path;
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
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => demoMethod(),
            ),
          ),
          FutureBuilder(
            future: demoMethod(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('error:${snapshot.error}');
              } else {
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Text('hello ${demo[index]}');
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: demo.length,
                  ),
                );
              }
            },
          )
          // FutureBuilder(
          //   future: searchYoutube(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData == false) {
          //       return const CircularProgressIndicator();
          //     } else if (snapshot.hasError) {
          //       return Text('error:${snapshot.error}');
          //     } else {
          //       return Expanded(
          //         child: ListView.separated(
          //           itemBuilder: (context, index) {
          //             var value = false;
          //             return ListTile(
          //               leading: Image.network(
          //                   youtubeVideos[index].thumbnail.small.url!),
          //               title: Text(youtubeVideos[index].title),
          //               onTap: () async => _downloadYoutubeAudio(
          //                 videoId: youtubeVideos[index].id!,
          //                 path:
          //                     '${await _getExternalDir}/${youtubeVideos[index].title}.wav',
          //               ),
          //               trailing: Checkbox(
          //                 value: value,
          //                 onChanged: (newValue) {
          //                   print(newValue);
          //                   setState(() {
          //                     value = newValue!;
          //                   });
          //                 },
          //               ),
          //             );
          //           },
          //           separatorBuilder: (context, index) => const Divider(),
          //           itemCount: youtubeVideos.length,
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
