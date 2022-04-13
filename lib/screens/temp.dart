import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:only_for_me/screens/search.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_api/youtube_api.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static Map<String, List<YouTubeVideo>> playlist = {};

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
  double _height = 100, _width = 600;
  bool isExpand = false;

  void test() {
    // var youtube = YouTubeVideo();
  }

  Future<File> get _localPlaylistFile async =>
      File('${await _getExternalDir}/playlist.json');

  void initPlaylistFile() async {
    final _file = await _localPlaylistFile;
    var _fileContent = '';
    if (await _file.exists()) {
      _fileContent = await _file.readAsString();
      var _content = await rootBundle.loadString('assets/test.json');
      _fileContent = _content;
    } else {
      var _content = await rootBundle.loadString('assets/test.json');
      _fileContent = _content;
      _file.writeAsString(_fileContent);
    }

    // MyApp.playlist = jsonDecode(_fileContent) as Map<String, List<dynamic>>;
    print('_fileContent:$_fileContent');
  }

  void userLoginCheck() {}

  @override
  void initState() {
    initPlaylistFile();
    userLoginCheck();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  get _getExternalDir async {
    var _externalStorageDirectory = await getExternalStorageDirectory();
    return _externalStorageDirectory?.path;
  }

  void printFile() async {}

  Widget category() {
    return Flexible(
      child: ListView.builder(
        itemCount: MyApp.playlist.length,
        itemBuilder: (context, index) {
          var songs = MyApp.playlist[MyApp.playlist.keys.elementAt(index)];

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    MyApp.playlist.keys.elementAt(index),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => Get.to(() => const SearchPage()),
        ),
      ),
      body: const SearchPage(),
      // body: Stack(
      //   alignment: Alignment.bottomCenter,
      //   children: [
      //     Container(
      //       color: Colors.amber,
      //     ),
      //     GestureDetector(
      //       onVerticalDragUpdate: (details) {
      //         if (details.delta.dy < 0) {
      //           setState(() {
      //             _height = MediaQuery.of(context).size.height;
      //           });
      //         }

      //         if (details.delta.dy > 0) {
      //           setState(() {
      //             _height = 100;
      //           });
      //         }
      //       },
      //       child: AnimatedContainer(
      //         height: _height,
      //         width: _width,
      //         onEnd: () {
      //           setState(() {
      //             isExpand = _height != 100;
      //           });
      //         },
      //         duration: const Duration(milliseconds: 500),
      //         color: Colors.black,
      //         curve: Curves.fastOutSlowIn,
      //         child: isExpand
      //             ? Flexible(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text(
      //                       '${MyApp.playlist['K-POP']?[0]['title']}',
      //                       style: const TextStyle(
      //                           fontSize: 30, fontWeight: FontWeight.bold),
      //                     ),
      //                     Image.network(
      //                       '${MyApp.playlist['K-POP']?[0]['thumbnail'][1]}',
      //                     ),
      //                     const SizedBox(
      //                       height: 100,
      //                     ),
      //                     ProgressBar(
      //                         progress: Duration(seconds: 10),
      //                         total: Duration(seconds: 100))
      //                   ],
      //                 ),
      //               )
      //             : Row(
      //                 children: [
      //                   Image.network(
      //                       '${MyApp.playlist['K-POP']?[0]['thumbnail'][0]}'),
      //                   Column(
      //                     children: [
      //                       Text(
      //                         '${MyApp.playlist['K-POP']?[0]['title']}',
      //                         style: TextStyle(color: Colors.white),
      //                       ),
      //                     ],
      //                   )
      //                 ],
      //               ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
