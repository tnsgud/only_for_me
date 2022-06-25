import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:only_for_me/models/song.dart';
import 'package:only_for_me/screens/search.dart';
import 'package:only_for_me/utils/utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Song> playList = [];
  AudioPlayer audioPlayer = AudioPlayer();

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

  Future<List<Song>> _getPlayListData() async {
    var list = <Song>[];
    var collection = Utils.getCurrentCollection;
    var snapshot = await collection.get();

    if (snapshot.docs.isEmpty) {
      return list;
    }

    for (var doc in snapshot.docs) {
      var data = doc.data();
      var song = Song(
        id: data['id'],
        title: data['title'],
        thumbnail: data['thumbnail'],
        url: data['url'],
        path: kIsWeb ? '' : '${await Utils.getExternalDir}/${data["id"]}.mp3',
      );
      list.add(song);
    }

    return list;
  }

  Future<List<Song>> initialPlayList() async {
    playList = await _getPlayListData();

    // if (!File(playList[0].path).existsSync()) {
    //   _downloadYoutubeAudio(videoId: playList[0].id, path: playList[0].path);
    // }

    // var audioSource = playList.map((e) => e.source).toList();

    // await audioPlayer.setAudioSource(
    //   ConcatenatingAudioSource(
    //     children: audioSource,
    //   ),
    // );

    return playList;
  }

  @override
  void initState() {
    super.initState();
    initialPlayList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.menu)),
        title: const Text('내 음악'),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: initialPlayList(),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) {
            //   return const CircularProgressIndicator();
            // }

            if (playList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '플레이 리스트가 비어있습니다.\n노래를 추가해보세요!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const SearchPage()),
                      child: const Text('노래 추가하기'),
                    )
                  ],
                ),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(playList[index].thumbnail),
                  title: Text(
                    playList[index].title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    if (!File(playList[index].path).existsSync()) {
                      _downloadYoutubeAudio(
                          videoId: playList[index].id,
                          path: playList[index].path);
                    }

                    await audioPlayer.seek(const Duration(seconds: 5),
                        index: index);
                    audioPlayer.play();
                  },
                );
              },
              itemCount: playList.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: '음악 추가',
        backgroundColor: Colors.deepPurple[400],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => const SearchPage());
          initialPlayList();
        },
      ),
    );
  }

  Widget _myMusic() {
    return TextButton(
      onPressed: () async {
        log('hello');
        var collection = Utils.getCurrentCollection;
        var snapshot = await collection.get();
        for (var element in snapshot.docs) {
          log('${element.data()}');
        }
      },
      child: const Text('get data'),
    );
  }

  Widget _myMusicBox() {
    return const Text('box');
  }
}
