import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<YouTubeVideo> youtubeVideos = [];
  List<bool> isSelected = [];
  final TextEditingController _controller = TextEditingController();

  Future searchYoutube() async {
    if (_controller.text.isEmpty || youtubeVideos.isNotEmpty) {
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

    isSelected = List<bool>.filled(youtubeVideos.length, false);

    return youtubeVideos;
  }

  void savePlayList() async {
    // for (var item in isSelected.where((element) => element).map((e) => isSelected.indexOf(e))) {
    //   if(item && MyApp.playlist['K-POP'].contains(element)){

    //   }
    // }
    // print(MyApp.playlist.keys);
    // print(MyApp.playlist);
  }

  void addMusic() async {
    var collection = Utils.getCurrentCollection;
    var snapshot = await collection.get();
    var docs = snapshot.docs;

    youtubeVideos
        .where(
            (youtubeVideo) => isSelected[youtubeVideos.indexOf(youtubeVideo)])
        .forEach(
      (youtubeVideo) async {
        if (docs.where((doc) => doc['id'] == youtubeVideo.id).isNotEmpty) {
          return;
        }

        await collection.add(
          {
            'id': youtubeVideo.id,
            'title': youtubeVideo.title,
            'url': youtubeVideo.url,
            'thumbnail': youtubeVideo.thumbnail.medium.url
          },
        );
      },
    );
  }

  @override
  void initState() {
    youtubeVideos.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _controller,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'search'),
          onSubmitted: (value) {
            setState(() {
              youtubeVideos.clear();
            });
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: searchYoutube(),
            builder: (context, snapshot) {
              if (!snapshot.hasData &&
                  _controller.text.isNotEmpty &&
                  youtubeVideos.isEmpty) {
                return const Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 15,
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        secondary: Image.network(
                          youtubeVideos[index].thumbnail.small.url!,
                        ),
                        title: Text(
                          youtubeVideos[index].title,
                        ),
                        onChanged: (bool? value) {
                          log('${youtubeVideos[index]}');
                          setState(() {
                            isSelected[index] = value!;
                          });
                        },
                        value: isSelected[index],
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: youtubeVideos.length,
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: isSelected.contains(true)
          ? FloatingActionButton(
              tooltip: 'add Playlist',
              child: const Icon(Icons.add),
              onPressed: () {
                addMusic();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('이미 플레이리스트에 추가된 곡은 제외했습니다.'),
                  ),
                );
              },
            )
          : null,
    );
  }
}
